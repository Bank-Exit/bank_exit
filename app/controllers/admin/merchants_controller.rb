module Admin
  class MerchantsController < BaseController
    before_action :set_merchant, only: %i[
      show edit update destroy
    ]

    # @route GET /fr/admin/merchants {locale: "fr"} (admin_merchants_fr)
    # @route GET /es/admin/merchants {locale: "es"} (admin_merchants_es)
    # @route GET /de/admin/merchants {locale: "de"} (admin_merchants_de)
    # @route GET /it/admin/merchants {locale: "it"} (admin_merchants_it)
    # @route GET /en/admin/merchants {locale: "en"} (admin_merchants_en)
    # @route GET /admin/merchants
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

      merchants = MerchantDecorator.wrap(merchants.distinct.reverse_order)

      @last_update = last_update.to_i

      @pagy, @merchants = pagy_array(merchants)
    end

    # @route GET /fr/admin/merchants/:id {locale: "fr"} (admin_merchant_fr)
    # @route GET /es/admin/merchants/:id {locale: "es"} (admin_merchant_es)
    # @route GET /de/admin/merchants/:id {locale: "de"} (admin_merchant_de)
    # @route GET /it/admin/merchants/:id {locale: "it"} (admin_merchant_it)
    # @route GET /en/admin/merchants/:id {locale: "en"} (admin_merchant_en)
    # @route GET /admin/merchants/:id
    def show
      authorize! @merchant

      comments = CommentDecorator.wrap(@merchant.comments)
      @pagy, @comments = pagy_array(comments)

      set_meta_tags title: @merchant.name
    end

    # @route GET /fr/admin/merchants/:id/edit {locale: "fr"} (edit_admin_merchant_fr)
    # @route GET /es/admin/merchants/:id/edit {locale: "es"} (edit_admin_merchant_es)
    # @route GET /de/admin/merchants/:id/edit {locale: "de"} (edit_admin_merchant_de)
    # @route GET /it/admin/merchants/:id/edit {locale: "it"} (edit_admin_merchant_it)
    # @route GET /en/admin/merchants/:id/edit {locale: "en"} (edit_admin_merchant_en)
    # @route GET /admin/merchants/:id/edit
    def edit
      authorize! @merchant
    end

    # @route PATCH /fr/admin/merchants/:id {locale: "fr"} (admin_merchant_fr)
    # @route PATCH /es/admin/merchants/:id {locale: "es"} (admin_merchant_es)
    # @route PATCH /de/admin/merchants/:id {locale: "de"} (admin_merchant_de)
    # @route PATCH /it/admin/merchants/:id {locale: "it"} (admin_merchant_it)
    # @route PATCH /en/admin/merchants/:id {locale: "en"} (admin_merchant_en)
    # @route PATCH /admin/merchants/:id
    # @route PUT /fr/admin/merchants/:id {locale: "fr"} (admin_merchant_fr)
    # @route PUT /es/admin/merchants/:id {locale: "es"} (admin_merchant_es)
    # @route PUT /de/admin/merchants/:id {locale: "de"} (admin_merchant_de)
    # @route PUT /it/admin/merchants/:id {locale: "it"} (admin_merchant_it)
    # @route PUT /en/admin/merchants/:id {locale: "en"} (admin_merchant_en)
    # @route PUT /admin/merchants/:id
    def update
      authorize! @merchant

      if @merchant.update(merchant_update_params)
        flash[:notice] = t('.notice')

        redirect_to admin_merchants_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/merchants/:id {locale: "fr"} (admin_merchant_fr)
    # @route DELETE /es/admin/merchants/:id {locale: "es"} (admin_merchant_es)
    # @route DELETE /de/admin/merchants/:id {locale: "de"} (admin_merchant_de)
    # @route DELETE /it/admin/merchants/:id {locale: "it"} (admin_merchant_it)
    # @route DELETE /en/admin/merchants/:id {locale: "en"} (admin_merchant_en)
    # @route DELETE /admin/merchants/:id
    def destroy
      authorize! @merchant

      @merchant.destroy

      flash[:notice] = t('.notice')

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
