class MerchantProposalIssue < ApplicationService
  ALLOWED_ATTRIBUTES = %w[
    name category other_category
    street postcode city country
    latitude longitude
    phone website description coins ask_kyc
    contact_facebook contact_twitter contact_telegram
    contact_signal contact_session contact_tripadvisor
    contact_matrix contact_jabber contact_youtube
    contact_linkedin contact_instagram contact_tiktok
    contact_odysee contact_crowdbunker contact_francelibretv
    delivery delivery_zone last_survey_on
  ].freeze

  attr_reader :merchant_proposal

  def initialize(merchant_proposal)
    @merchant_proposal = merchant_proposal.decorate
  end

  def call
    GithubAPI.new.create_issue!(
      title: title,
      body: body,
      labels: labels
    )
  end

  private

  def title
    "Proposal for a new merchant: `#{merchant_proposal.name}`"
  end

  def body
    <<~MARKDOWN
      A new proposition for a merchant has been submitted. Please take a look and add it to OpenStreetMap if relevant:

      ```yaml
      #{attributes.compact.to_yaml}
      ```

      ---

      *Note: this issue has been automatically opened from bank-exit website using the Github API.*
    MARKDOWN
  end

  def labels
    [
      'merchant',
      'proposal',
      I18n.t(I18n.locale, scope: 'languages', locale: :en)
    ]
  end

  def attributes
    hash = merchant_proposal.attributes.slice(*ALLOWED_ATTRIBUTES)

    hash['category'] = if merchant_proposal.other_category_selected?
                         merchant_proposal.other_category
                       else
                         I18n.t(merchant_proposal.category, scope: 'categories', default: merchant_proposal.category)
                       end

    hash['country'] = merchant_proposal.pretty_country if merchant_proposal.country.present?
    hash
  end
end
