class MerchantProposal
  include ActiveModel::Model
  include ActiveModel::Attributes

  ALLOWED_COINS = %i[
    bitcoin monero june lightning
    contact_less gold silver
  ].freeze

  attribute :name, :string
  attribute :description
  attribute :category, :string
  attribute :other_category, :string
  attribute :street, :string
  attribute :postcode, :string
  attribute :city, :string
  attribute :country, :string
  attribute :phone, :string
  attribute :email, :string
  attribute :website, :string
  attribute :opening_hours, :string
  attribute :nickname, :string

  attribute :delivery, :boolean, default: false
  attribute :delivery_zone, :string
  attribute :last_survey_on, :date
  attribute :proposition_from, :string

  attribute :coins, default: -> { [] }
  attribute :ask_kyc, :boolean, default: false

  attribute :contact_facebook, :string
  attribute :contact_twitter, :string
  attribute :contact_telegram, :string
  attribute :contact_signal, :string
  attribute :contact_session, :string
  attribute :contact_odysee, :string
  attribute :contact_crowdbunker, :string
  attribute :contact_francelibretv, :string
  attribute :contact_tripadvisor, :string
  attribute :contact_matrix, :string
  attribute :contact_jabber, :string
  attribute :contact_youtube, :string
  attribute :contact_linkedin, :string
  attribute :contact_instagram, :string
  attribute :contact_tiktok, :string

  validates :name, presence: true
  validates :street, presence: true
  validates :postcode, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :category, presence: true, inclusion: { in: I18n.t('categories').keys.push(:other).map(&:to_s) }, allow_blank: false
  validates :other_category, presence: true, if: :other_category_selected?
  validates :description, presence: true
  validates :coins, presence: true, inclusion: { in: ALLOWED_COINS.map(&:to_s) }
  validates :proposition_from, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Captcha used to trick bots
  validates :nickname, absence: true

  def other_category_selected?
    category == 'other'
  end

  def decorate
    MerchantProposalDecorator.new(self)
  end
end
