class NostrPublisher < ApplicationService
  attr_reader :merchant_sync, :identifier

  def initialize(merchant_sync, identifier:)
    @merchant_sync = merchant_sync
    @identifier = identifier
    @responses = Set.new
  end

  def prepare
    validate!
  end

  def call
    return unless merchants_count.positive?

    @nostr_event = merchant_sync.nostr_event || merchant_sync.create_nostr_event!(identifier: identifier)

    relays.each do |relay|
      @client = Nostr::Client.new(
        private_key: private_key,
        relay: relay
      )

      @event = Nostr::Event.new(
        kind: 30_023, # Long-form Content
        pubkey: @client.public_key,
        tags: tags,
        content: content
      )

      @client.connect
      @event = @client.sign(@event)
      response = @client.publish_and_wait(@event, close_on_finish: true)

      @responses << response
    rescue StandardError => e
      Rails.logger.error { e.message }
      next
    end

    raise NostrErrors::PublicationError if @responses.blank?

    response = @responses.first

    @nostr_event.update!(
      event_identifier: response.event_id,
      payload_event: @event,
      payload_response: response
    )

    response
  end

  private

  def validate!
    raise NostrErrors::MissingPrivateKey unless private_key
    raise NostrErrors::MissingRelayUrl if relays.blank?
  end

  def tags
    default_tags = [
      ['d', identifier],
      ['title', title],
      ['summary', summary],
      %w[t Bank-Exit],
      %w[t SortieDeBanque],
      ['published_at', published_at]
    ]

    lightning = coins_list.include?('lightning') || coins_list.include?('lightning_contactless')

    if coins_list.include?('bitcoin') || lightning
      default_tags.push(%w[t XBT])
      default_tags.push(%w[t Bitcoin])
    end

    default_tags.push(%w[t LightningNetwork]) if lightning

    if coins_list.include?('monero')
      default_tags.push(%w[t XMR])
      default_tags.push(%w[t Monero])
    end

    if coins_list.include?('june')
      default_tags.push(%w[t XG1])
      default_tags.push(%w[t June])
    end

    default_tags.push(['p', original_bank_exit_pubkey]) if original_bank_exit_pubkey
    default_tags
  end

  def coins_list
    @coins_list ||= Set.new(merchants.pluck(:coins).flatten.compact)
  end

  def title
    @title ||= "New Bank-Exit merchants (#{I18n.l(merchant_sync.started_at)})"
  end

  def summary
    @summary ||= 'A list of merchants that accept Bitcoin, Monero, or June, mapped on the bank-exit.org website during the latest synchronization.'
  end

  def content
    @content ||= ApplicationController.render(
      partial: 'nostr/merchants/list',
      locals: {
        merchants_count: merchants_count,
        merchants_by_country: merchants.group_by(&:country),
        coins_list: coins_list
      }
    )
  end

  def published_at
    @published_at ||= Time.current.to_i.to_s
  end

  def merchants
    @merchants ||=
      MerchantDecorator.wrap(
        Merchant
        .available
        .where.not(country: nil)
        .where(
          original_identifier: merchant_sync.payload_added_merchants.pluck('id')
        )
      )
  end

  def merchants_count
    merchant_sync.added_merchants_count
  end

  def private_key
    ENV.fetch('NOSTR_PRIVATE_KEY', nil)
  end

  def relays
    ENV.fetch('NOSTR_RELAYS_URLS', nil)&.split(';')
  end

  def original_bank_exit_pubkey
    ENV.fetch('NOSTR_BANK_EXIT_PUBKEY', nil)
  end
end
