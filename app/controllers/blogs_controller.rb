class BlogsController < PublicController
  before_action :set_blog, only: :show

  add_breadcrumb proc { I18n.t('application.nav.menu.home') }, :root_path
  add_breadcrumb proc { I18n.t('application.nav.menu.articles') }
  add_breadcrumb proc { I18n.t('application.nav.menu.blogs') }, :blogs_path

  # @route GET /fr/blogs {locale: "fr"} (blogs_fr)
  # @route GET /es/blogs {locale: "es"} (blogs_es)
  # @route GET /de/blogs {locale: "de"} (blogs_de)
  # @route GET /it/blogs {locale: "it"} (blogs_it)
  # @route GET /en/blogs {locale: "en"} (blogs_en)
  # @route GET /blogs
  def index
    @blogs = Blog.all(decorate: true)
  end

  # @route GET /fr/blogs/:id {locale: "fr"} (blog_fr)
  # @route GET /es/blogs/:id {locale: "es"} (blog_es)
  # @route GET /de/blogs/:id {locale: "de"} (blog_de)
  # @route GET /it/blogs/:id {locale: "it"} (blog_it)
  # @route GET /en/blogs/:id {locale: "en"} (blog_en)
  # @route GET /blogs/:id
  def show
    add_breadcrumb @blog.title, blog_path(@blog)

    set_meta_tags title: @blog.title,
                  description: @blog.short_description
  end

  private

  def set_blog
    @blog = Blog.find(params[:id], decorate: true)
  end
end
