module Merchants
  class ReportsController < PublicController
    before_action :set_merchant

    # @route GET /fr/merchants/:merchant_id/report/new {locale: "fr"} (new_merchant_report_fr)
    # @route GET /es/merchants/:merchant_id/report/new {locale: "es"} (new_merchant_report_es)
    # @route GET /de/merchants/:merchant_id/report/new {locale: "de"} (new_merchant_report_de)
    # @route GET /it/merchants/:merchant_id/report/new {locale: "it"} (new_merchant_report_it)
    # @route GET /en/merchants/:merchant_id/report/new {locale: "en"} (new_merchant_report_en)
    # @route GET /merchants/:merchant_id/report/new
    def new
      @merchant_report = MerchantReport.new
    end

    # @route POST /fr/merchants/:merchant_id/report {locale: "fr"} (merchant_report_fr)
    # @route POST /es/merchants/:merchant_id/report {locale: "es"} (merchant_report_es)
    # @route POST /de/merchants/:merchant_id/report {locale: "de"} (merchant_report_de)
    # @route POST /it/merchants/:merchant_id/report {locale: "it"} (merchant_report_it)
    # @route POST /en/merchants/:merchant_id/report {locale: "en"} (merchant_report_en)
    # @route POST /merchants/:merchant_id/report
    def create
      @merchant_report = MerchantReport.new(merchant_report_params)

      if bot?
        # Prank bot with a 200
        flash.now[:notice] = t('.notice')
        head :ok
      elsif @merchant_report.valid?
        if FeatureFlag.enabled?(:github)
          # Only call the Github API issue in production
          MerchantReportIssue.call(@merchant, @merchant_report)
        end

        MerchantMailer
          .with(merchant: @merchant.object, description: description)
          .send_report_merchant
          .deliver_later

        flash.now[:notice] = t('.notice')
      else
        render :new, status: :unprocessable_content
      end
    rescue StandardError => e
      flash.now[:alert] = e.message
      render status: :unprocessable_content
    end

    private

    def merchant_report_params
      params.expect(merchant_report: %i[description nickname])
    end

    def set_merchant
      @merchant = Merchant.find_by!(identifier: merchant_id).decorate
    end

    def merchant_id
      params[:merchant_id].split('-').first
    end

    def description
      merchant_report_params[:description]
    end

    def bot?
      merchant_report_params[:nickname].present?
    end
  end
end
