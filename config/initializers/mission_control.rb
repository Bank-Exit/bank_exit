Rails.application.configure do
  MissionControl::Jobs.base_controller_class = 'Admin::BaseController'
  MissionControl::Jobs.http_basic_auth_enabled = false

  config.after_initialize do
    require 'patches/mission_control'
  end
end
