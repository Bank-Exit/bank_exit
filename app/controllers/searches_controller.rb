class SearchesController < PublicController
  # @route GET /fr/search {locale: "fr"} (search_fr)
  # @route GET /es/search {locale: "es"} (search_es)
  # @route GET /de/search {locale: "de"} (search_de)
  # @route GET /it/search {locale: "it"} (search_it)
  # @route GET /en/search {locale: "en"} (search_en)
  # @route GET /search
  def show
    if params[:page].nil? || params.expect(:page).to_i == 1
      if query.present?
        tutorials = Tutorial.by_query(query)
        @query_tutorials = TutorialDecorator.wrap(tutorials)

        blogs = Blog.by_query(query)
        @query_blogs = BlogDecorator.wrap(blogs)

        projects = Project.by_query(query)
        @query_projects = ProjectDecorator.wrap(projects)
      end

      directories_filter = Directories::Filter.call(query: query)
      @directories = DirectoryDecorator.wrap(directories_filter)
    end

    @pagy, merchants = pagy(Merchant.available.by_query(query).with_attached_logo.order(last_survey_on: :desc), limit: 32)
    @merchants = MerchantDecorator.wrap(merchants)
  end

  private

  def query
    @query ||= params[:query]
  end
end
