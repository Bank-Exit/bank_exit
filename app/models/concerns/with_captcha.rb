# Use this concern when you need to add an invisible captcha
# that tricks bot to a form model.
#
# You can use it like that:
#
#   class MyModel
#     include WithCaptcha
#
#     captcha :nickname
#   end
#
#   my_instance = MyModel.new
#   my_instance.nickname = 'iamabot'
#   my_instance.valid?
#   #=> false
module WithCaptcha
  extend ActiveSupport::Concern

  module ClassMethods
    def captcha(attribute)
      attribute(attribute, :string)
      validates(attribute, absence: true)
    end
  end
end
