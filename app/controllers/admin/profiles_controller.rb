module Admin
  class ProfilesController < BaseController
    # @route GET /fr/admin/profile/edit {locale: "fr"} (edit_admin_profile_fr)
    # @route GET /es/admin/profile/edit {locale: "es"} (edit_admin_profile_es)
    # @route GET /de/admin/profile/edit {locale: "de"} (edit_admin_profile_de)
    # @route GET /it/admin/profile/edit {locale: "it"} (edit_admin_profile_it)
    # @route GET /en/admin/profile/edit {locale: "en"} (edit_admin_profile_en)
    # @route GET /admin/profile/edit
    def edit
      authorize! current_user, with: ProfilePolicy
    end

    # @route PATCH /fr/admin/profile {locale: "fr"} (admin_profile_fr)
    # @route PATCH /es/admin/profile {locale: "es"} (admin_profile_es)
    # @route PATCH /de/admin/profile {locale: "de"} (admin_profile_de)
    # @route PATCH /it/admin/profile {locale: "it"} (admin_profile_it)
    # @route PATCH /en/admin/profile {locale: "en"} (admin_profile_en)
    # @route PATCH /admin/profile
    # @route PUT /fr/admin/profile {locale: "fr"} (admin_profile_fr)
    # @route PUT /es/admin/profile {locale: "es"} (admin_profile_es)
    # @route PUT /de/admin/profile {locale: "de"} (admin_profile_de)
    # @route PUT /it/admin/profile {locale: "it"} (admin_profile_it)
    # @route PUT /en/admin/profile {locale: "en"} (admin_profile_en)
    # @route PUT /admin/profile
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
