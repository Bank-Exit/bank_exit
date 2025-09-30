module Merchants
  # Some trolls could remove data for nothing on OSM. This service
  # helps to identify if a removal is legit or a dirty one by opening
  # an issue at Github with removed merchant references.
  class CheckAndReportRemovedOnOSM < ApplicationService
    include ApplicationHelper
    include Rails.application.routes.url_helpers

    attr_reader :geojson_merchant_ids

    def initialize(geojson_merchant_ids)
      @geojson_merchant_ids = geojson_merchant_ids
    end

    def call
      @diff_ids = Merchant.pluck(:original_identifier) - geojson_merchant_ids

      # Mark record as soft deleted
      merchants
        .where(deleted_at: nil)
        .update_all(deleted_at: Time.current)

      if Rails.env.test? || Rails.env.production?
        # Report to Github issue merchants removed from OSM
        # but still present in Bank-Exit map.
        GithubAPI.new.update_issue!(github_issue_id, body: body)
      end

      output_folder = "#{files_folder_prefix}/merchants"
      FileUtils.mkdir_p(output_folder)

      File.write(
        "#{output_folder}/removed_merchants_from_open_street_map.txt",
        body
      )
    end

    private

    def body
      if @diff_ids.empty?
        <<~MARKDOWN
          There are no Monero/June merchants disabled for now 🎉

          ---

          *Note: this issue has been automatically updated from bank-exit website using the Github API.*
        MARKDOWN
      else
        <<~MARKDOWN
          **#{merchants_list.count}** Monero and/or June merchants seems to have been removed on OpenStreetMap but are still present in Bank-Exit.org website.
          Please check the relevance of the information below:

          #{merchants_list.join("\n")}

          ---

          *Note: this issue has been automatically updated from bank-exit website using the Github API.*
        MARKDOWN
      end
    end

    def merchants
      @merchants ||= Merchant
                     .where(original_identifier: @diff_ids)
                     .merge(Merchant.monero.or(Merchant.june))
                     .order(deleted_at: :desc)
    end

    def merchants_list
      @merchants_list ||= MerchantDecorator.wrap(merchants).map do |merchant|
        <<~MARKDOWN
          - [ ] **#{merchant.name}** [##{merchant.identifier}] #{pretty_country_html(merchant.country)}
            - Date: #{I18n.l(merchant.deleted_at)}
            - Coins: #{merchant.coins.map(&:capitalize).join(', ')}
            - [On Bank-Exit](#{merchant_url(merchant, debug: 'true')})
            - [On OpenStreetMap](#{merchant.osm_link})
        MARKDOWN
      end
    end

    def github_issue_id
      ENV.fetch('GITHUB_REPORT_REMOVED_MERCHANTS_ISSUE_ID')
    end
  end
end
