module Sorcery
  module TestHelpers
    module Rails
      module Request
        def login_user(user = nil, password = 'password', route = nil, http_method = :post)
          user ||= @user
          route ||= session_url

          username_attr = user.sorcery_config.username_attribute_names.first
          username = user.send(username_attr)
          password_attr = user.sorcery_config.password_attribute_name

          send(http_method, route, params: { session: { "#{username_attr}": username, "#{password_attr}": password } })
        end

        def logout_user(route = nil, http_method = :delete)
          route ||= session_url

          send(http_method, route)
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Request, type: :request
end
