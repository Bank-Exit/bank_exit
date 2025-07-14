module Admin
  class AnnouncementsController < BaseController
    before_action :set_announcement, only: %i[
      show edit update destroy
    ]

    # @route GET /admin/announcements (admin_announcements)
    def index
      authorize!

      @pagy, @announcements = pagy(Announcement.all)
    end

    # @route GET /admin/announcements/new (new_admin_announcement)
    def new
      authorize!

      @announcement = Announcement.new
    end

    # @route POST /admin/announcements (admin_announcements)
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

    # @route GET /admin/announcements/:id (admin_announcement)
    def show
      authorize! @announcement
    end

    # @route GET /admin/announcements/:id/edit (edit_admin_announcement)
    def edit
      authorize! @announcement
    end

    # @route PATCH /admin/announcements/:id (admin_announcement)
    # @route PUT /admin/announcements/:id (admin_announcement)
    def update
      authorize! @announcement

      if @announcement.update(announcement_params)
        flash[:notice] = t('.notice')

        redirect_to admin_announcements_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /admin/announcements/:id (admin_announcement)
    def destroy
      authorize! @announcement

      @announcement.destroy

      flash[:notice] = t('.notice')

      redirect_to admin_announcements_path
    end

    private

    def announcement_params
      params.expect(announcement: %i[
                      title description locale mode enabled picture
                      link_to_visit published_at unpublished_at
                      remove_picture
                    ])
    end

    def set_announcement
      @announcement = Announcement.find(params[:id])
    end
  end
end
