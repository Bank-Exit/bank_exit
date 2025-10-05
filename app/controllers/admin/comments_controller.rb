module Admin
  class CommentsController < BaseController
    before_action :set_comment, only: %i[update destroy]

    # @route GET /fr/admin/comments {locale: "fr"} (admin_comments_fr)
    # @route GET /es/admin/comments {locale: "es"} (admin_comments_es)
    # @route GET /de/admin/comments {locale: "de"} (admin_comments_de)
    # @route GET /it/admin/comments {locale: "it"} (admin_comments_it)
    # @route GET /en/admin/comments {locale: "en"} (admin_comments_en)
    # @route GET /admin/comments
    def index
      authorize!

      @dashboard_presenter = Admin::DashboardPresenter.new

      comments = Comment.includes(:commentable)
      comments = comments.flagged if show_flagged?
      comments = CommentDecorator.wrap(comments)

      @pagy, @comments = pagy_array(comments)
    end

    # @route PATCH /fr/admin/comments/:id {locale: "fr"} (admin_comment_fr)
    # @route PATCH /es/admin/comments/:id {locale: "es"} (admin_comment_es)
    # @route PATCH /de/admin/comments/:id {locale: "de"} (admin_comment_de)
    # @route PATCH /it/admin/comments/:id {locale: "it"} (admin_comment_it)
    # @route PATCH /en/admin/comments/:id {locale: "en"} (admin_comment_en)
    # @route PATCH /admin/comments/:id
    # @route PUT /fr/admin/comments/:id {locale: "fr"} (admin_comment_fr)
    # @route PUT /es/admin/comments/:id {locale: "es"} (admin_comment_es)
    # @route PUT /de/admin/comments/:id {locale: "de"} (admin_comment_de)
    # @route PUT /it/admin/comments/:id {locale: "it"} (admin_comment_it)
    # @route PUT /en/admin/comments/:id {locale: "en"} (admin_comment_en)
    # @route PUT /admin/comments/:id
    def update
      authorize! @comment

      @comment.update(flag_reason: nil)

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_comments_path
    end

    # @route DELETE /fr/admin/comments/:id {locale: "fr"} (admin_comment_fr)
    # @route DELETE /es/admin/comments/:id {locale: "es"} (admin_comment_es)
    # @route DELETE /de/admin/comments/:id {locale: "de"} (admin_comment_de)
    # @route DELETE /it/admin/comments/:id {locale: "it"} (admin_comment_it)
    # @route DELETE /en/admin/comments/:id {locale: "en"} (admin_comment_en)
    # @route DELETE /admin/comments/:id
    def destroy
      authorize! @comment

      @comment.destroy

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_comments_path
    end

    private

    def set_comment
      @comment = Comment.find(params[:id]).decorate
    end

    def show_flagged?
      params[:show_flagged] == 'true'
    end
  end
end
