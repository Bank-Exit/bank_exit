Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker

  draw :legacy
  draw :shortcuts

  namespace :maps do
    resource :referer, only: :update
  end

  localized do
    root 'welcome#index'

    resource :session, only: %i[new create destroy]
    get '/:locale/session', to: redirect('/%{locale}/session/new')
    get '/session', to: redirect('/session/new')

    resource :collective, only: :show
    resource :ecosystem, only: :show
    resources :coins, only: :show
    resources :local_groups, only: %i[index]

    resources :questions, only: [] do
      collection do
        get :results
        post :fetch_levels
        post :fetch_services
      end
    end

    get '/map/embed', to: 'maps/embeds#show', as: :maps_embed

    constraints zoom: /\d+/,
                lat: /[+-]?(\d*\.)?\d+/,
                lon: /[+-]?(\d*\.)?\d+/ do
      get '/map', to: 'maps#index', as: :maps
      get '/map/:zoom', to: 'maps#index'
      get '/map/:zoom/:lat', to: 'maps#index'
      get '/map/:zoom/:lat/:lon', to: 'maps#index', as: :pretty_map
    end

    get '/map/fetch_markers', to: 'maps#fetch_markers'
    get '/map/merchants(.:format)', to: 'maps#export_merchants', as: :export_merchants

    resources :projects, only: :show

    resources :merchant_proposals, only: %i[index new create]

    concern :commentable do
      resources :comments, only: %i[new create] do
        scope module: :comments do
          resource :report, only: %i[new create]
        end
      end
    end

    resources :merchants, only: %i[show], concerns: :commentable do
      post :refresh, on: :collection

      scope module: :merchants do
        resource :popup, only: :show
        resource :itinerary, only: %i[new create]
        resource :report, only: %i[new create]
      end
    end

    resources :directories, only: %i[index new create show], concerns: :commentable
    resources :coin_wallets, only: :show
    resources :delivery_zones, only: [] do
      collection do
        get :mode_values
      end
    end

    resource :faq, only: %i[show]
    resources :risks, only: %i[index]
    resources :media, only: %i[index]
    resources :contacts, only: %i[show]

    resources :blogs, only: %i[index show]
    resources :tutorials, only: %i[index show] do
      scope module: :tutorials do
        resource :report, only: %i[new create]
      end
    end

    resource :statistics, only: :show, path: 'stats' do
      get :daily_merchants
    end

    resource :glossaries, only: :show
    resources :announcements, only: :index

    namespace :admin do
      root 'dashboards#show'
      resource :dashboard, only: %i[show]

      mount MissionControl::Jobs::Engine, at: '/jobs'
      mount ActiveAnalytics::Engine, at: '/analytics' if ENV.fetch('FF_ANALYTICS_ENABLED', false) == 'true'

      resources :users, except: :show do
        post :impersonate, on: :member
        post :stop_impersonating, on: :collection
      end

      resource :profile, only: %i[edit update]

      resources :merchants, only: %i[index show edit update destroy] do
        scope module: :merchants do
          resource :reactivate, only: :create

          member do
            resource :directory_converters, only: :create
          end

          collection do
            resource :batch_actions, only: %i[update destroy], as: :merchants_batch_actions
          end
        end
      end

      resources :comments, only: %i[index update destroy]
      resources :directories, except: :show do
        member do
          patch :update_position
        end
      end

      resources :announcements
      resources :ecosystem_items, except: :show
    end

    namespace :api do
      namespace :v1 do
        resources :merchants, only: %i[index show]
      end
    end
  end

  namespace :addresses do
    resource :search, only: :show
  end

  namespace :statistics do
    post :toggle_atms
  end

  resource :license, only: :show

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
