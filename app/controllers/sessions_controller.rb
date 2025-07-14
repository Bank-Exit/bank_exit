class SessionsController < PublicController
  skip_after_action :record_page_view

  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: 'Try again later.' }

  # @route GET /fr/session/new {locale: "fr"} (new_session_fr)
  # @route GET /es/session/new {locale: "es"} (new_session_es)
  # @route GET /de/session/new {locale: "de"} (new_session_de)
  # @route GET /it/session/new {locale: "it"} (new_session_it)
  # @route GET /en/session/new {locale: "en"} (new_session_en)
  # @route GET /session/new
  def new
    redirect_to admin_root_path if logged_in?
  end

  # @route POST /fr/session {locale: "fr"} (session_fr)
  # @route POST /es/session {locale: "es"} (session_es)
  # @route POST /de/session {locale: "de"} (session_de)
  # @route POST /it/session {locale: "it"} (session_it)
  # @route POST /en/session {locale: "en"} (session_en)
  # @route POST /session
  def create
    @user = login(session_params[:email], session_params[:password])

    if @user&.enabled?
      redirect_back_or_to admin_root_path
    else
      logout
      flash.now[:alert] = 'Login failed'

      render action: 'new', status: :unprocessable_content
    end
  end

  # @route DELETE /fr/session {locale: "fr"} (session_fr)
  # @route DELETE /es/session {locale: "es"} (session_es)
  # @route DELETE /de/session {locale: "de"} (session_de)
  # @route DELETE /it/session {locale: "it"} (session_it)
  # @route DELETE /en/session {locale: "en"} (session_en)
  # @route DELETE /session
  def destroy
    logout
    redirect_to new_session_path, status: :see_other
  end

  private

  def session_params
    params.expect(session: %i[email password])
  end
end
