MissionControl::Jobs::ApplicationController.class_eval do
  before_action :require_authorization

  verify_authorized

  private

  def require_authorization
    authorize! to: :mission_control?, with: Admin::UserPolicy
  end
end
