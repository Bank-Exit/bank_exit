class MerchantReport
  include ActiveModel::Model
  include ActiveModel::Attributes
  include WithCaptcha

  attribute :description, :string
  captcha :nickname

  validates :description, presence: true
end
