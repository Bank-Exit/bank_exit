module Admin
  class CommentsController < BaseController
    before_action :set_comment, only: %i[update destroy]

    # @route GET /admin/comments (admin_comments)
    def index
      authorize!

      @dashboard_presenter = Admin::DashboardPresenter.new

      comments = Comment.includes(:commentable)
      comments = comments.flagged if show_flagged?
      comments = CommentDecorator.wrap(comments)

      @pagy, @comments = pagy_array(comments)
    end

    # @route PATCH /admin/comments/:id (admin_comment)
    # @route PUT /admin/comments/:id (admin_comment)
    def update
      authorize! @comment

      @comment.update(flag_reason: nil)

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_comments_path
    end

    # @route DELETE /admin/comments/:id (admin_comment)
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
