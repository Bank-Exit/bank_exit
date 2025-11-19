class CommentPolicy < ApplicationPolicy
  pre_check :require_comments_enabled!

  def index?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end

  def report?
    record.flag_reason.blank?
  end

  private

  def require_comments_enabled!
    deny! unless comments_enabled?
  end

  def comments_enabled?
    FeatureFlag.enabled?(:comments)
  end
end
