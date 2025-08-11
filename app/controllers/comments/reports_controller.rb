module Comments
  class ReportsController < PublicController
    before_action :set_comment

    # @route GET /fr/comments/:comment_id/report/new {locale: "fr"} (new_comment_report_fr)
    # @route GET /es/comments/:comment_id/report/new {locale: "es"} (new_comment_report_es)
    # @route GET /de/comments/:comment_id/report/new {locale: "de"} (new_comment_report_de)
    # @route GET /it/comments/:comment_id/report/new {locale: "it"} (new_comment_report_it)
    # @route GET /en/comments/:comment_id/report/new {locale: "en"} (new_comment_report_en)
    # @route GET /comments/:comment_id/report/new
    def new
      authorize! @comment, to: :report?

      @comment_report = CommentReport.new
    end

    # @route POST /fr/comments/:comment_id/report {locale: "fr"} (comment_report_fr)
    # @route POST /es/comments/:comment_id/report {locale: "es"} (comment_report_es)
    # @route POST /de/comments/:comment_id/report {locale: "de"} (comment_report_de)
    # @route POST /it/comments/:comment_id/report {locale: "it"} (comment_report_it)
    # @route POST /en/comments/:comment_id/report {locale: "en"} (comment_report_en)
    # @route POST /comments/:comment_id/report
    def create
      authorize! @comment, to: :report?

      @comment_report = CommentReport.new(comment_report_params)

      if bot?
        # Prank bot with a 200
        flash.now[:notice] = t('.notice')
        head :ok
      elsif @comment_report.valid?
        @comment.update(flag_reason: @comment_report.flag_reason)

        CommentMailer
          .with(comment: @comment.object, description: description)
          .send_report_comment
          .deliver_later

        flash.now[:notice] = t('.notice')
      else
        render :new, status: :unprocessable_content
      end
    end

    private

    def comment_report_params
      params.expect(comment_report: %i[flag_reason description nickname])
    end

    def set_comment
      @comment = Comment.find(params[:comment_id]).decorate
    end

    def description
      comment_report_params[:description]
    end

    def bot?
      comment_report_params[:nickname].present?
    end
  end
end
