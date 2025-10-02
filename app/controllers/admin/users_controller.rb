module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[
      edit update destroy impersonate
    ]

    # @route GET /admin/users (admin_users)
    def index
      authorize! User

      @pagy, @users = pagy(User.all)
    end

    # @route GET /admin/users/new (new_admin_user)
    def new
      authorize! User

      @user = User.new
    end

    # @route POST /admin/users (admin_users)
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

    # @route GET /admin/users/:id/edit (edit_admin_user)
    def edit
      authorize! @user
    end

    # @route PATCH /admin/users/:id (admin_user)
    # @route PUT /admin/users/:id (admin_user)
    def update
      authorize! @user

      if @user.update(user_params)
        flash[:notice] = t('.notice')

        redirect_to admin_users_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # @route DELETE /admin/users/:id (admin_user)
    def destroy
      authorize! @user

      @user.destroy

      flash[:notice] = t('.notice')

      redirect_back_or_to admin_users_path
    end

    # @route POST /admin/users/:id/impersonate (impersonate_admin_user)
    def impersonate
      authorize! @user

      impersonate_user(@user)
      redirect_to admin_dashboard_path
    end

    # @route POST /admin/users/stop_impersonating (stop_impersonating_admin_users)
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
