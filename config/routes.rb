BeachApiCore::Engine.routes.draw do
  use_doorkeeper

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: 'json' } ) do
    resources :applications, except: %i(new edit)
    resources :sessions, only: :create, path: :auth
    resources :favourites, only: %i(index create destroy)
    resources :entities, only: %i(show create destroy)
    resources :webhooks, only: %i(index create destroy)
    resources :users, only: %i(create) do
      post :confirm, on: :member
    end
    resource :password, only: %i(create update)
    resource :user, only: %i(show update)
    resources :services, only: %i(index update) do
      resource :capabilities, only: %i(create destroy)
    end
    resources :service_categories, only: %i(create update index)
    resources :teams, except: %i(new edit index)
    resources :organisations, except: %i(new edit) do
      get :users, on: :collection
      put :current, on: :member
    end
    resources :assignments, only: %i(create destroy)
    resources :memberships, only: %i(create destroy)
    resources :invitations, only: %i(index create destroy) do
      post :accept, on: :member
    end
    resources :atoms, only: %i(create index show) do
      collection do
        put :update
        delete :destroy
      end
      resource :permission, only: %i(show) do
        post :set
      end
    end
    resources :roles, only: %i(index)
    resources :settings, only: %i(update)
    resources :emails, only: %i(create)
    resources :jobs, only: %i(create show destroy)
    resources :projects, only: %i(create show update destroy)
    resources :broadcasts, only: %i(create)
  end
end
