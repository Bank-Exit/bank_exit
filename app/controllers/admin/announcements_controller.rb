module Admin
  class AnnouncementsController < BaseController
    before_action :set_announcement, only: %i[
      show edit update destroy
    ]

    # @route GET /fr/admin/announcements {locale: "fr"} (admin_announcements_fr)
    # @route GET /es/admin/announcements {locale: "es"} (admin_announcements_es)
    # @route GET /de/admin/announcements {locale: "de"} (admin_announcements_de)
    # @route GET /it/admin/announcements {locale: "it"} (admin_announcements_it)
    # @route GET /en/admin/announcements {locale: "en"} (admin_announcements_en)
    # @route GET /admin/announcements
    def index
      authorize!

      @pagy, @announcements = pagy(Announcement.all)
    end

    # @route GET /fr/admin/announcements/new {locale: "fr"} (new_admin_announcement_fr)
    # @route GET /es/admin/announcements/new {locale: "es"} (new_admin_announcement_es)
    # @route GET /de/admin/announcements/new {locale: "de"} (new_admin_announcement_de)
    # @route GET /it/admin/announcements/new {locale: "it"} (new_admin_announcement_it)
    # @route GET /en/admin/announcements/new {locale: "en"} (new_admin_announcement_en)
    # @route GET /admin/announcements/new
    def new
      authorize!

      @announcement = Announcement.new
    end

    # @route POST /fr/admin/announcements {locale: "fr"} (admin_announcements_fr)
    # @route POST /es/admin/announcements {locale: "es"} (admin_announcements_es)
    # @route POST /de/admin/announcements {locale: "de"} (admin_announcements_de)
    # @route POST /it/admin/announcements {locale: "it"} (admin_announcements_it)
    # @route POST /en/admin/announcements {locale: "en"} (admin_announcements_en)
    # @route POST /admin/announcements
    def create
      authorize!

      @announcement = Announcement.new(announcement_params)

      if @announcement.save
        flash[:notice] = t('.notice')

        redirect_to admin_announcements_path
      else
        render :new, status: :unprocessable_content
      end
    end

    # @route GET /fr/admin/announcements/:id {locale: "fr"} (admin_announcement_fr)
    # @route GET /es/admin/announcements/:id {locale: "es"} (admin_announcement_es)
    # @route GET /de/admin/announcements/:id {locale: "de"} (admin_announcement_de)
    # @route GET /it/admin/announcements/:id {locale: "it"} (admin_announcement_it)
    # @route GET /en/admin/announcements/:id {locale: "en"} (admin_announcement_en)
    # @route GET /admin/announcements/:id
    def show
      authorize! @announcement
    end

    # @route GET /fr/admin/announcements/:id/edit {locale: "fr"} (edit_admin_announcement_fr)
    # @route GET /es/admin/announcements/:id/edit {locale: "es"} (edit_admin_announcement_es)
    # @route GET /de/admin/announcements/:id/edit {locale: "de"} (edit_admin_announcement_de)
    # @route GET /it/admin/announcements/:id/edit {locale: "it"} (edit_admin_announcement_it)
    # @route GET /en/admin/announcements/:id/edit {locale: "en"} (edit_admin_announcement_en)
    # @route GET /admin/announcements/:id/edit
    def edit
      authorize! @announcement
    end

    # @route PATCH /fr/admin/announcements/:id {locale: "fr"} (admin_announcement_fr)
    # @route PATCH /es/admin/announcements/:id {locale: "es"} (admin_announcement_es)
    # @route PATCH /de/admin/announcements/:id {locale: "de"} (admin_announcement_de)
    # @route PATCH /it/admin/announcements/:id {locale: "it"} (admin_announcement_it)
    # @route PATCH /en/admin/announcements/:id {locale: "en"} (admin_announcement_en)
    # @route PATCH /admin/announcements/:id
    # @route PUT /fr/admin/announcements/:id {locale: "fr"} (admin_announcement_fr)
    # @route PUT /es/admin/announcements/:id {locale: "es"} (admin_announcement_es)
    # @route PUT /de/admin/announcements/:id {locale: "de"} (admin_announcement_de)
    # @route PUT /it/admin/announcements/:id {locale: "it"} (admin_announcement_it)
    # @route PUT /en/admin/announcements/:id {locale: "en"} (admin_announcement_en)
    # @route PUT /admin/announcements/:id
    def update
      authorize! @announcement

      if @announcement.update(announcement_params)
        flash[:notice] = t('.notice')

        redirect_to admin_announcements_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/announcements/:id {locale: "fr"} (admin_announcement_fr)
    # @route DELETE /es/admin/announcements/:id {locale: "es"} (admin_announcement_es)
    # @route DELETE /de/admin/announcements/:id {locale: "de"} (admin_announcement_de)
    # @route DELETE /it/admin/announcements/:id {locale: "it"} (admin_announcement_it)
    # @route DELETE /en/admin/announcements/:id {locale: "en"} (admin_announcement_en)
    # @route DELETE /admin/announcements/:id
    def destroy
      authorize! @announcement

      @announcement.destroy

      flash[:notice] = t('.notice')

      redirect_to admin_announcements_path
    end

    private

    def announcement_params
      translated_params = I18n.available_locales.map do |l|
        [
          :"title_#{Mobility.normalize_locale(l)}",
          :"description_#{Mobility.normalize_locale(l)}",
          :"link_to_visit_#{Mobility.normalize_locale(l)}"
        ]
      end.flatten

      params.expect(announcement: %i[
        mode enabled picture remove_picture
        published_at unpublished_at
      ].push(translated_params))
    end

    def set_announcement
      @announcement = Announcement.find(params[:id])
    end
  end
end
