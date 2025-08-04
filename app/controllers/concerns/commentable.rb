module Commentable
  extend ActiveSupport::Concern

  included do
    before_action :set_comments, only: [:show] # rubocop:disable Rails/LexicallyScopedActionFilter
  end

  private

  def set_comments
    comments = CommentDecorator.wrap(commentable.comments)

    @pagy, @comments = pagy_array(comments, limit: 5)
  end

  def commentable
    raise NoMethodError, 'You must define #commentable in your controller'
  end
end
