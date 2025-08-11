module Admin
  class MerchantsController < BaseController
    before_action :set_merchant, only: %i[
      show edit update destroy
    ]

    # @route GET /admin/merchants (admin_merchants)
    def index
      session[:admin_merchant_referer_url] = request.url

      @dashboard_presenter = Admin::DashboardPresenter.new
      @merchants_statistics = @dashboard_presenter.merchants_statistics

      merchants = Merchant.order(updated_at: :asc)
      merchants = merchants.deleted if show_deleted?

      merchants = FilterMerchants.call(
        merchants,
        query: query,
        category: category,
        country: country,
        coins: coins,
        with_atms: true
      )
      merchants = merchants.where.associated(:comments) if with_comments?

      merchants = MerchantDecorator.wrap(merchants.reverse_order)

      @last_update = last_update.to_i

      @pagy, @merchants = pagy_array(merchants)

      respond_to do |format|
        format.html
        format.turbo_stream unless show_deleted?
      end

      set_meta_tags title: 'Les commerçants'
    end

    # @route GET /admin/merchants/:id (admin_merchant)
    def show
      authorize! @merchant

      comments = CommentDecorator.wrap(@merchant.comments)
      @pagy, @comments = pagy_array(comments)

      set_meta_tags title: @merchant.name
    end

    # @route GET /admin/merchants/:id/edit (edit_admin_merchant)
    def edit
      authorize! @merchant
    end

    # @route PATCH /admin/merchants/:id (admin_merchant)
    # @route PUT /admin/merchants/:id (admin_merchant)
    def update
      authorize! @merchant

      if @merchant.update(merchant_update_params)
        flash[:notice] = 'Le commerçant a bien été modifié'

        redirect_to admin_merchants_path(format: :html)
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /admin/merchants/:id (admin_merchant)
    def destroy
      authorize! @merchant

      @merchant.destroy

      flash[:notice] = 'Le commerçant a bien été supprimé'

      redirect_back_or_to admin_merchants_path(show_deleted: true)
    end

    private

    def merchant_params
      params.permit(
        :query, :category, :country,
        :with_comments, :show_deleted, coins: []
      )
    end

    def merchant_update_params
      params.expect(
        merchant: %i[
          logo banner remove_logo remove_banner
        ]
      )
    end

    def set_merchant
      @merchant = Merchant.find_by!(identifier: merchant_id).decorate
    end

    def query
      @query ||= merchant_params[:query]
    end

    def category
      @category ||= merchant_params[:category]
    end

    def country
      @country ||= merchant_params[:country]
    end

    def coins
      @coins ||= merchant_params[:coins] || []
    end

    def with_comments?
      params[:with_comments] == '1'
    end

    def show_deleted?
      params[:show_deleted] == 'true'
    end

    def merchant_id
      params[:id].split('-').first
    end

    def last_update
      File.read('storage/last_fetch_at.txt')
    rescue Errno::ENOENT
      nil
    end
  end
end
