module Tutorials
  class ReportsController < PublicController
    before_action :set_tutorial

    # @route GET /fr/tutorials/:tutorial_id/report/new {locale: "fr"} (new_tutorial_report_fr)
    # @route GET /es/tutorials/:tutorial_id/report/new {locale: "es"} (new_tutorial_report_es)
    # @route GET /de/tutorials/:tutorial_id/report/new {locale: "de"} (new_tutorial_report_de)
    # @route GET /it/tutorials/:tutorial_id/report/new {locale: "it"} (new_tutorial_report_it)
    # @route GET /en/tutorials/:tutorial_id/report/new {locale: "en"} (new_tutorial_report_en)
    # @route GET /tutorials/:tutorial_id/report/new
    def new
      @tutorial_report = TutorialReport.new
    end

    # @route POST /fr/tutorials/:tutorial_id/report {locale: "fr"} (tutorial_report_fr)
    # @route POST /es/tutorials/:tutorial_id/report {locale: "es"} (tutorial_report_es)
    # @route POST /de/tutorials/:tutorial_id/report {locale: "de"} (tutorial_report_de)
    # @route POST /it/tutorials/:tutorial_id/report {locale: "it"} (tutorial_report_it)
    # @route POST /en/tutorials/:tutorial_id/report {locale: "en"} (tutorial_report_en)
    # @route POST /tutorials/:tutorial_id/report
    def create
      @tutorial_report = TutorialReport.new(tutorial_report_params)

      if bot?
        # Prank bot with a 200
        flash.now[:notice] = t('.notice')
        head :ok
      elsif @tutorial_report.valid?
        if FeatureFlag.enabled?(:github)
          # Only call the Github API issue in production
          TutorialReportIssue.call(@tutorial, @tutorial_report)
        end

        flash.now[:notice] = t('.notice')
      else
        render :new, status: :unprocessable_content
      end
    rescue StandardError => e
      flash.now[:alert] = e.message
      render status: :unprocessable_content
    end

    private

    def tutorial_report_params
      params.expect(tutorial_report: %i[title description nickname])
    end

    def set_tutorial
      @tutorial = Tutorial.find(params[:tutorial_id])
    end

    def bot?
      tutorial_report_params[:nickname].present?
    end
  end
end
