class CommentReport
  include ActiveModel::Model
  include ActiveModel::Attributes
  include WithCaptcha

  attribute :description, :string
  attribute :flag_reason, :string
  captcha :nickname

  validates :description, presence: true
  validates :flag_reason, presence: true,
                          inclusion: { in: Comment.flag_reasons.keys }
end
