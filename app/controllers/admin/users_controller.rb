module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[
      edit update destroy impersonate
    ]

    # @route GET /fr/admin/users {locale: "fr"} (admin_users_fr)
    # @route GET /es/admin/users {locale: "es"} (admin_users_es)
    # @route GET /de/admin/users {locale: "de"} (admin_users_de)
    # @route GET /it/admin/users {locale: "it"} (admin_users_it)
    # @route GET /en/admin/users {locale: "en"} (admin_users_en)
    # @route GET /admin/users
    def index
      authorize! User

      @pagy, @users = pagy(User.all)
    end

    # @route GET /fr/admin/users/new {locale: "fr"} (new_admin_user_fr)
    # @route GET /es/admin/users/new {locale: "es"} (new_admin_user_es)
    # @route GET /de/admin/users/new {locale: "de"} (new_admin_user_de)
    # @route GET /it/admin/users/new {locale: "it"} (new_admin_user_it)
    # @route GET /en/admin/users/new {locale: "en"} (new_admin_user_en)
    # @route GET /admin/users/new
    def new
      authorize! User

      @user = User.new
    end

    # @route POST /fr/admin/users {locale: "fr"} (admin_users_fr)
    # @route POST /es/admin/users {locale: "es"} (admin_users_es)
    # @route POST /de/admin/users {locale: "de"} (admin_users_de)
    # @route POST /it/admin/users {locale: "it"} (admin_users_it)
    # @route POST /en/admin/users {locale: "en"} (admin_users_en)
    # @route POST /admin/users
    def create
      authorize! User

      @user = User.new(user_params)

      if @user.save
        flash[:notice] = t('.notice')

        redirect_to admin_users_path
      else
        render :new, status: :unprocessable_content
      end
    end

    # @route GET /fr/admin/users/:id/edit {locale: "fr"} (edit_admin_user_fr)
    # @route GET /es/admin/users/:id/edit {locale: "es"} (edit_admin_user_es)
    # @route GET /de/admin/users/:id/edit {locale: "de"} (edit_admin_user_de)
    # @route GET /it/admin/users/:id/edit {locale: "it"} (edit_admin_user_it)
    # @route GET /en/admin/users/:id/edit {locale: "en"} (edit_admin_user_en)
    # @route GET /admin/users/:id/edit
    def edit
      authorize! @user
    end

    # @route PATCH /fr/admin/users/:id {locale: "fr"} (admin_user_fr)
    # @route PATCH /es/admin/users/:id {locale: "es"} (admin_user_es)
    # @route PATCH /de/admin/users/:id {locale: "de"} (admin_user_de)
    # @route PATCH /it/admin/users/:id {locale: "it"} (admin_user_it)
    # @route PATCH /en/admin/users/:id {locale: "en"} (admin_user_en)
    # @route PATCH /admin/users/:id
    # @route PUT /fr/admin/users/:id {locale: "fr"} (admin_user_fr)
    # @route PUT /es/admin/users/:id {locale: "es"} (admin_user_es)
    # @route PUT /de/admin/users/:id {locale: "de"} (admin_user_de)
    # @route PUT /it/admin/users/:id {locale: "it"} (admin_user_it)
    # @route PUT /en/admin/users/:id {locale: "en"} (admin_user_en)
    # @route PUT /admin/users/:id
    def update
      authorize! @user

      if @user.update(user_params)
        flash[:notice] = t('.notice')

        redirect_to admin_users_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # @route DELETE /fr/admin/users/:id {locale: "fr"} (admin_user_fr)
    # @route DELETE /es/admin/users/:id {locale: "es"} (admin_user_es)
    # @route DELETE /de/admin/users/:id {locale: "de"} (admin_user_de)
    # @route DELETE /it/admin/users/:id {locale: "it"} (admin_user_it)
    # @route DELETE /en/admin/users/:id {locale: "en"} (admin_user_en)
    # @route DELETE /admin/users/:id
    def destroy
      authorize! @user

      @user.destroy

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_users_path
    end

    # @route POST /fr/admin/users/:id/impersonate {locale: "fr"} (impersonate_admin_user_fr)
    # @route POST /es/admin/users/:id/impersonate {locale: "es"} (impersonate_admin_user_es)
    # @route POST /de/admin/users/:id/impersonate {locale: "de"} (impersonate_admin_user_de)
    # @route POST /it/admin/users/:id/impersonate {locale: "it"} (impersonate_admin_user_it)
    # @route POST /en/admin/users/:id/impersonate {locale: "en"} (impersonate_admin_user_en)
    # @route POST /admin/users/:id/impersonate
    def impersonate
      authorize! @user

      impersonate_user(@user)
      redirect_to admin_dashboard_path
    end

    # @route POST /fr/admin/users/stop_impersonating {locale: "fr"} (stop_impersonating_admin_users_fr)
    # @route POST /es/admin/users/stop_impersonating {locale: "es"} (stop_impersonating_admin_users_es)
    # @route POST /de/admin/users/stop_impersonating {locale: "de"} (stop_impersonating_admin_users_de)
    # @route POST /it/admin/users/stop_impersonating {locale: "it"} (stop_impersonating_admin_users_it)
    # @route POST /en/admin/users/stop_impersonating {locale: "en"} (stop_impersonating_admin_users_en)
    # @route POST /admin/users/stop_impersonating
    def stop_impersonating
      stop_impersonating_user
      redirect_to admin_users_path
    end

    private

    def user_params
      params.expect(user: %i[email password password_confirmation role enabled])
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
