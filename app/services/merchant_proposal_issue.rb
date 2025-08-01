class MerchantProposalIssue < ApplicationService
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

      ```json
      #{JSON.pretty_generate(merchant_proposal.to_osm)}
      ```

      Description:
      ```
      #{merchant_proposal.description}
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
end
