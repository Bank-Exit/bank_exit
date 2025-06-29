# This class acts as a model (not related to the database)
# to interact more elegantly with the FAQs data.
class FAQ
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Findable

  attribute :question, :string
  attribute :identifier, :string

  attr_accessor :content, :categories, :answer
end
