module TokenAuthenticable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token

  # To authenticate a service with a token.
  #
  # Render an :unauthorized if failed.
  def authenticate
    authenticate!
  rescue AuthenticableErrors::UnauthorizedToken => e
    render_unauthorized_authentication(e.message)
  rescue AuthenticableErrors::ForbiddenToken => e
    render_forbidden_authentication(e.message)
  end

  # @raise [AuthenticableErrors::Unauthorized] if authentication failed
  # @raise [AuthenticableErrors::UnauthorizedIp] if authentication succeed but IP not allowed
  def authenticate!
    raise AuthenticableErrors::UnauthorizedToken unless current_api_token
    raise AuthenticableErrors::ForbiddenToken unless current_api_token.live?
  end

  # Load and return the current {ExternalServiceToken} from headers or params.
  #
  # @return [ExternalServiceToken] if token valid
  # @return [nil] otherwise
  def current_api_token
    return @current_api_token if defined?(@current_api_token)

    @current_api_token = APIToken.find_by(
      token: token_from_headers || token_from_params
    )
  end

  # Respond an unauthorized message and status with an +WWW-Authenticate+ header
  #
  # @return [JSON]
  def render_unauthorized_authentication(message = nil)
    response.headers['WWW-Authenticate'] = 'Bearer realm="Bank-Exit", error="invalid_token"'

    render json: {
      errors: [
        {
          status: '401',
          title: 'Unauthorized',
          detail: message
        }
      ]
    }, status: :unauthorized
  end

  def render_forbidden_authentication(message = nil)
    response.headers['WWW-Authenticate'] = 'Bearer realm="Bank-Exit", error="disabled_or_expired_token"'

    render json: {
      errors: [
        {
          status: '403',
          title: 'Forbidden',
          detail: message
        }
      ]
    }, status: :forbidden
  end

  private

  def token_from_headers
    token_and_options(request)&.first
  end

  def token_from_params
    params[:token]
  end
end
