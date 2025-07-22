class ProjectsController < PublicController
  before_action :set_project, only: :show

  # @route GET /fr/projects/:id {locale: "fr"} (project_fr)
  # @route GET /es/projects/:id {locale: "es"} (project_es)
  # @route GET /de/projects/:id {locale: "de"} (project_de)
  # @route GET /it/projects/:id {locale: "it"} (project_it)
  # @route GET /en/projects/:id {locale: "en"} (project_en)
  # @route GET /projects/:id
  def show
    redirect_to @project.link if @project.flyer?

    set_meta_tags title: @project.title,
                  description: @project.description
  end

  private

  def set_project
    @project = Project.find(identifier, decorate: true)
  end

  def identifier
    params[:id].presence || 'sticker'
  end
end
