class CommentsController < PublicController
  before_action :set_commentable

  # @route GET /fr/merchants/:merchant_id/comments/new {locale: "fr"} (new_merchant_comment_fr)
  # @route GET /es/merchants/:merchant_id/comments/new {locale: "es"} (new_merchant_comment_es)
  # @route GET /de/merchants/:merchant_id/comments/new {locale: "de"} (new_merchant_comment_de)
  # @route GET /it/merchants/:merchant_id/comments/new {locale: "it"} (new_merchant_comment_it)
  # @route GET /en/merchants/:merchant_id/comments/new {locale: "en"} (new_merchant_comment_en)
  # @route GET /merchants/:merchant_id/comments/new
  # @route GET /fr/directories/:directory_id/comments/new {locale: "fr"} (new_directory_comment_fr)
  # @route GET /es/directories/:directory_id/comments/new {locale: "es"} (new_directory_comment_es)
  # @route GET /de/directories/:directory_id/comments/new {locale: "de"} (new_directory_comment_de)
  # @route GET /it/directories/:directory_id/comments/new {locale: "it"} (new_directory_comment_it)
  # @route GET /en/directories/:directory_id/comments/new {locale: "en"} (new_directory_comment_en)
  # @route GET /directories/:directory_id/comments/new
  def new
    authorize! Comment

    respond_to do |format|
      format.turbo_stream do
        @comment = @commentable.comments.new(rating: nil)
      end
    end
  end

  # @route POST /fr/merchants/:merchant_id/comments {locale: "fr"} (merchant_comments_fr)
  # @route POST /es/merchants/:merchant_id/comments {locale: "es"} (merchant_comments_es)
  # @route POST /de/merchants/:merchant_id/comments {locale: "de"} (merchant_comments_de)
  # @route POST /it/merchants/:merchant_id/comments {locale: "it"} (merchant_comments_it)
  # @route POST /en/merchants/:merchant_id/comments {locale: "en"} (merchant_comments_en)
  # @route POST /merchants/:merchant_id/comments
  # @route POST /fr/directories/:directory_id/comments {locale: "fr"} (directory_comments_fr)
  # @route POST /es/directories/:directory_id/comments {locale: "es"} (directory_comments_es)
  # @route POST /de/directories/:directory_id/comments {locale: "de"} (directory_comments_de)
  # @route POST /it/directories/:directory_id/comments {locale: "it"} (directory_comments_it)
  # @route POST /en/directories/:directory_id/comments {locale: "en"} (directory_comments_en)
  # @route POST /directories/:directory_id/comments
  def create
    authorize! Comment

    @comment = @commentable.comments.new(comment_params) do |model|
      model.language = I18n.locale
    end
    @comment = @comment.decorate

    if @comment.nickname.present?
      # Prank bot with a 200
      flash.now[:notice] = t('.notice')
      head :ok
    elsif @comment.save
      flash.now[:notice] = t('.notice')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def comment_params
    params.expect(comment: %i[content rating pseudonym affidavit nickname])
  end

  def set_commentable
    @commentable = find_commentable
  end

  def find_commentable
    klass = [Merchant, Directory].detect { params["#{it.name.underscore}_id"] }

    case klass.to_s
    when 'Merchant'
      identifier = params['merchant_id'].split('-')
      @commentable = klass.find_by(identifier: identifier)
    when 'Directory'
      @commentable = klass.find(params[:directory_id])
    end
  end
end
