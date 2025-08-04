module Comments
  class ReportsController < PublicController
    before_action :set_commentable
    before_action :set_comment

    # @route GET /fr/merchants/:merchant_id/comments/:comment_id/report/new {locale: "fr"} (new_merchant_comment_report_fr)
    # @route GET /es/merchants/:merchant_id/comments/:comment_id/report/new {locale: "es"} (new_merchant_comment_report_es)
    # @route GET /de/merchants/:merchant_id/comments/:comment_id/report/new {locale: "de"} (new_merchant_comment_report_de)
    # @route GET /it/merchants/:merchant_id/comments/:comment_id/report/new {locale: "it"} (new_merchant_comment_report_it)
    # @route GET /en/merchants/:merchant_id/comments/:comment_id/report/new {locale: "en"} (new_merchant_comment_report_en)
    # @route GET /merchants/:merchant_id/comments/:comment_id/report/new
    # @route GET /fr/directories/:directory_id/comments/:comment_id/report/new {locale: "fr"} (new_directory_comment_report_fr)
    # @route GET /es/directories/:directory_id/comments/:comment_id/report/new {locale: "es"} (new_directory_comment_report_es)
    # @route GET /de/directories/:directory_id/comments/:comment_id/report/new {locale: "de"} (new_directory_comment_report_de)
    # @route GET /it/directories/:directory_id/comments/:comment_id/report/new {locale: "it"} (new_directory_comment_report_it)
    # @route GET /en/directories/:directory_id/comments/:comment_id/report/new {locale: "en"} (new_directory_comment_report_en)
    # @route GET /directories/:directory_id/comments/:comment_id/report/new
    def new
      authorize! @comment, to: :report?

      @comment_report = CommentReport.new
    end

    # @route POST /fr/merchants/:merchant_id/comments/:comment_id/report {locale: "fr"} (merchant_comment_report_fr)
    # @route POST /es/merchants/:merchant_id/comments/:comment_id/report {locale: "es"} (merchant_comment_report_es)
    # @route POST /de/merchants/:merchant_id/comments/:comment_id/report {locale: "de"} (merchant_comment_report_de)
    # @route POST /it/merchants/:merchant_id/comments/:comment_id/report {locale: "it"} (merchant_comment_report_it)
    # @route POST /en/merchants/:merchant_id/comments/:comment_id/report {locale: "en"} (merchant_comment_report_en)
    # @route POST /merchants/:merchant_id/comments/:comment_id/report
    # @route POST /fr/directories/:directory_id/comments/:comment_id/report {locale: "fr"} (directory_comment_report_fr)
    # @route POST /es/directories/:directory_id/comments/:comment_id/report {locale: "es"} (directory_comment_report_es)
    # @route POST /de/directories/:directory_id/comments/:comment_id/report {locale: "de"} (directory_comment_report_de)
    # @route POST /it/directories/:directory_id/comments/:comment_id/report {locale: "it"} (directory_comment_report_it)
    # @route POST /en/directories/:directory_id/comments/:comment_id/report {locale: "en"} (directory_comment_report_en)
    # @route POST /directories/:directory_id/comments/:comment_id/report
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

    def set_commentable
      @commentable = find_commentable
    end

    def find_commentable
      klass = [Merchant, Directory].detect { params["#{it.name.underscore}_id"] }

      case klass.to_s
      when 'Merchant'
        identifier = params['merchant_id'].split('-')
        @commentable = klass.find_by!(identifier: identifier)
      when 'Directory'
        @commentable = klass.find(params[:directory_id])
      end
    end

    def set_comment
      @comment = @commentable.comments.find(params[:comment_id]).decorate
    end

    def description
      comment_report_params[:description]
    end

    def bot?
      comment_report_params[:nickname].present?
    end
  end
end
