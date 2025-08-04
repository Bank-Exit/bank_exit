class TutorialReport
  include ActiveModel::Model
  include ActiveModel::Attributes
  include WithCaptcha

  attribute :title, :string
  attribute :description, :string
  captcha :nickname

  validates :title, presence: true
  validates :description, presence: true
end
