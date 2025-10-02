module Admin
  class ProfilesController < BaseController
    # @route GET /admin/profile/edit (edit_admin_profile)
    def edit
      authorize! current_user, with: ProfilePolicy
    end

    # @route PATCH /admin/profile (admin_profile)
    # @route PUT /admin/profile (admin_profile)
    def update
      authorize! current_user, with: ProfilePolicy

      if current_user.update(user_params)
        redirect_to admin_root_path, notice: t('.notice')
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def user_params
      params.expect(
        user: %i[email password password_confirmation]
      )
    end
  end
end
