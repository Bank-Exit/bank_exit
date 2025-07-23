class TutorialsController < PublicController
  before_action :set_tutorial, only: :show
  before_action :set_coins, only: :show

  add_breadcrumb proc { I18n.t('application.nav.menu.home') }, :root_path
  add_breadcrumb proc { I18n.t('application.nav.menu.articles') }
  add_breadcrumb proc { I18n.t('application.nav.menu.tutorials') }, :tutorials_path

  # @route GET /fr/tutorials {locale: "fr"} (tutorials_fr)
  # @route GET /es/tutorials {locale: "es"} (tutorials_es)
  # @route GET /de/tutorials {locale: "de"} (tutorials_de)
  # @route GET /it/tutorials {locale: "it"} (tutorials_it)
  # @route GET /en/tutorials {locale: "en"} (tutorials_en)
  # @route GET /tutorials
  def index
    tutorials = Tutorial.all(decorate: true)

    @highlighted_tutorials = tutorials.select(&:highlight?)
    @other_tutorials = tutorials.reject(&:highlight?)
  end

  # @route GET /fr/tutorials/:id {locale: "fr"} (tutorial_fr)
  # @route GET /es/tutorials/:id {locale: "es"} (tutorial_es)
  # @route GET /de/tutorials/:id {locale: "de"} (tutorial_de)
  # @route GET /it/tutorials/:id {locale: "it"} (tutorial_it)
  # @route GET /en/tutorials/:id {locale: "en"} (tutorial_en)
  # @route GET /tutorials/:id
  def show
    add_breadcrumb @tutorial.title, tutorial_path(@tutorial)

    set_meta_tags title: @tutorial.title,
                  description: @tutorial.short_description
  end

  private

  def set_tutorial
    @tutorial = Tutorial.find(params[:id], decorate: true)
  end

  def set_coins
    @coins = case params[:id]
             when 'cakewallet-monero', 'monero-node-easymonerod', 'funding-monero'
               [Coin.find('monero', decorate: true)]
             when 'bitcoin-nokyc'
               [Coin.find('bitcoin', decorate: true)]
             end
  end
end
