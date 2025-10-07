module Admin
  class APITokensController < BaseController
    before_action :set_api_token, only: %i[
      show edit update destroy
    ]

    # @route GET /fr/admin/api_tokens {locale: "fr"} (admin_api_tokens_fr)
    # @route GET /es/admin/api_tokens {locale: "es"} (admin_api_tokens_es)
    # @route GET /de/admin/api_tokens {locale: "de"} (admin_api_tokens_de)
    # @route GET /it/admin/api_tokens {locale: "it"} (admin_api_tokens_it)
    # @route GET /en/admin/api_tokens {locale: "en"} (admin_api_tokens_en)
    # @route GET /admin/api_tokens
    def index
      authorize!

      @pagy, @api_tokens = pagy(APIToken.all)
    end

    # @route GET /fr/admin/api_tokens/new {locale: "fr"} (new_admin_api_token_fr)
    # @route GET /es/admin/api_tokens/new {locale: "es"} (new_admin_api_token_es)
    # @route GET /de/admin/api_tokens/new {locale: "de"} (new_admin_api_token_de)
    # @route GET /it/admin/api_tokens/new {locale: "it"} (new_admin_api_token_it)
    # @route GET /en/admin/api_tokens/new {locale: "en"} (new_admin_api_token_en)
    # @route GET /admin/api_tokens/new
    def new
      authorize!

      @api_token = APIToken.new
    end

    # @route POST /fr/admin/api_tokens {locale: "fr"} (admin_api_tokens_fr)
    # @route POST /es/admin/api_tokens {locale: "es"} (admin_api_tokens_es)
    # @route POST /de/admin/api_tokens {locale: "de"} (admin_api_tokens_de)
    # @route POST /it/admin/api_tokens {locale: "it"} (admin_api_tokens_it)
    # @route POST /en/admin/api_tokens {locale: "en"} (admin_api_tokens_en)
    # @route POST /admin/api_tokens
    def create
      authorize!

      @api_token = APIToken.new(api_token_params)

      if @api_token.save
        flash[:notice] = t('.notice')

        redirect_to admin_api_tokens_path
      else
        render :new, status: :unprocessable_content
      end
    end

    # @route GET /fr/admin/api_tokens/:id {locale: "fr"} (admin_api_token_fr)
    # @route GET /es/admin/api_tokens/:id {locale: "es"} (admin_api_token_es)
    # @route GET /de/admin/api_tokens/:id {locale: "de"} (admin_api_token_de)
    # @route GET /it/admin/api_tokens/:id {locale: "it"} (admin_api_token_it)
    # @route GET /en/admin/api_tokens/:id {locale: "en"} (admin_api_token_en)
    # @route GET /admin/api_tokens/:id
    def show
      authorize! @api_token
    end

    # @route GET /fr/admin/api_tokens/:id/edit {locale: "fr"} (edit_admin_api_token_fr)
    # @route GET /es/admin/api_tokens/:id/edit {locale: "es"} (edit_admin_api_token_es)
    # @route GET /de/admin/api_tokens/:id/edit {locale: "de"} (edit_admin_api_token_de)
    # @route GET /it/admin/api_tokens/:id/edit {locale: "it"} (edit_admin_api_token_it)
    # @route GET /en/admin/api_tokens/:id/edit {locale: "en"} (edit_admin_api_token_en)
    # @route GET /admin/api_tokens/:id/edit
    def edit
      authorize! @api_token
    end

    # @route PATCH /fr/admin/api_tokens/:id {locale: "fr"} (admin_api_token_fr)
    # @route PATCH /es/admin/api_tokens/:id {locale: "es"} (admin_api_token_es)
    # @route PATCH /de/admin/api_tokens/:id {locale: "de"} (admin_api_token_de)
    # @route PATCH /it/admin/api_tokens/:id {locale: "it"} (admin_api_token_it)
    # @route PATCH /en/admin/api_tokens/:id {locale: "en"} (admin_api_token_en)
    # @route PATCH /admin/api_tokens/:id
    # @route PUT /fr/admin/api_tokens/:id {locale: "fr"} (admin_api_token_fr)
    # @route PUT /es/admin/api_tokens/:id {locale: "es"} (admin_api_token_es)
    # @route PUT /de/admin/api_tokens/:id {locale: "de"} (admin_api_token_de)
    # @route PUT /it/admin/api_tokens/:id {locale: "it"} (admin_api_token_it)
    # @route PUT /en/admin/api_tokens/:id {locale: "en"} (admin_api_token_en)
    # @route PUT /admin/api_tokens/:id
    def update
      authorize! @api_token

      if @api_token.update(api_token_params)
        flash[:notice] = t('.notice')

        redirect_to admin_api_tokens_path
      else
        render :edit, status: :unprocessable_content
      end
    end

    # @route DELETE /fr/admin/api_tokens/:id {locale: "fr"} (admin_api_token_fr)
    # @route DELETE /es/admin/api_tokens/:id {locale: "es"} (admin_api_token_es)
    # @route DELETE /de/admin/api_tokens/:id {locale: "de"} (admin_api_token_de)
    # @route DELETE /it/admin/api_tokens/:id {locale: "it"} (admin_api_token_it)
    # @route DELETE /en/admin/api_tokens/:id {locale: "en"} (admin_api_token_en)
    # @route DELETE /admin/api_tokens/:id
    def destroy
      authorize! @api_token

      @api_token.destroy

      flash[:notice] = t('.notice')

      redirect_to admin_api_tokens_path
    end

    private

    def api_token_params
      params.expect(
        api_token: %i[
          name description enabled expired_at
        ]
      )
    end

    def set_api_token
      @api_token = APIToken.find(params[:id])
    end
  end
end
