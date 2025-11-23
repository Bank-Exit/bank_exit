require 'rails_helper'

RSpec.describe NostrPublisher do
  let(:identifier) { 'foobar-123' }
  let(:merchant_sync) { create :merchant_sync }

  before { enable_feature :nostr }

  describe '#call' do
    subject(:call) do
      described_class
        .call(merchant_sync, identifier: identifier)
    end

    let(:client) { instance_double(Nostr::Client) }
    let(:published_event) { Struct.new(:event).new }

    before do
      allow(Nostr::Client).to receive(:new) { client }
      allow(client).to receive(:public_key) { 'fake_pubkey' }
      allow(client).to receive(:connect)
      allow(client).to receive(:close)
      allow(client).to receive(:sign) { |event| event }
      allow(client).to receive(:publish_and_wait) do |event|
        published_event.event = event
        { status: 'ok' }
      end
    end

    context 'when private key is missing' do
      before do
        stub_env('NOSTR_PRIVATE_KEY', nil)
      end

      it { expect { call }.to raise_error(NostrErrors::MissingPrivateKey) }
    end

    context 'when relays are not configured' do
      before do
        stub_env('NOSTR_RELAYS_URLS', nil)
      end

      it { expect { call }.to raise_error(NostrErrors::MissingRelayUrl) }
    end

    context 'when new merchant count is positive' do
      let(:merchant_sync) do
        create :merchant_sync,
               added_merchants_count: 3,
               payload_added_merchants: [
                 { 'id' => 'node/123' },
                 { 'id' => 'node/456' },
                 { 'id' => 'way/789' }
               ],
               started_at: Time.current
      end

      before do
        create :merchant, original_identifier: 'node/123', name: 'Bitcoin Coffee'
        create :merchant, original_identifier: 'node/456', name: 'MM salon de thé, pâtisserie, chocolaterie'
        create :merchant, original_identifier: 'way/789', name: 'Feel SO light'
        create :merchant, :deleted, original_identifier: 'node/111', name: 'Deleted merchant'

        travel_to Time.zone.local(2025, 11, 20, 16, 30, 00)

        call
      end

      it 'connects to relay', :aggregate_failures do
        expect(client).to have_received(:connect)
        expect(client).to have_received(:publish_and_wait)
        expect(client).to have_received(:close)
      end

      it 'has correct tags' do
        tags = published_event.event.tags

        expect(tags).to match_nostr_tags(
          d: 'foobar-123',
          title: 'New Bank-Exit merchants (2025-11-20 at 16:30)',
          summary: 'A list of merchants that accept Bitcoin, Monero, or June, mapped on the bank-exit.org website during the latest synchronization.',
          t: %w[Bank-Exit SortieDeBanque XBT XMR XG1 Bitcoin Monero June],
          p: 'mynostrpubkey',
          published_at: Time.current.to_i.to_s
        )
      end

      it 'has correct content', :aggregate_failures do
        content = published_event.event.content

        expect(content).to match(/Discover \*\*3\*\* newly listed Bitcoin \(₿ ⚡\), Monero \(🔒\), and June \(🟡\) merchants now featured on the /)
        expect(content).to match(/Bitcoin Coffee/)
        expect(content).to match(/MM salon de thé, pâtisserie, chocolaterie/)
        expect(content).to match(/Feel SO light/)
        expect(content).to_not match(/Deleted merchant/)
      end

      it 'has correct response payload', :aggregate_failures do
        expect(merchant_sync.reload.payload_nostr).to eq({
          event: published_event.event,
          response: { status: 'ok' }
        }.as_json)
      end
    end

    context 'when new merchant count is null' do
      let(:merchant_sync) do
        create :merchant_sync, added_merchants_count: 0
      end

      before { call }

      it 'does not connect to relay', :aggregate_failures do
        expect(client).to_not have_received(:connect)
        expect(client).to_not have_received(:publish_and_wait)
        expect(client).to_not have_received(:close)
      end
    end
  end
end
