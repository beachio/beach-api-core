BeachApiCore::Engine.routes.draw do
  use_doorkeeper

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: 'json' } ) do
    resources :applications, except: [:new, :edit]
    resources :sessions, only: :create, path: :auth
    resources :favourites, only: [:index, :create, :destroy]
    resources :users, only: [:create]
    resource :user, only: [:show, :update]
    resources :services, only: [:index, :update] do
      resource :capabilities, only: [:create, :destroy]
    end
    resources :service_categories, only: [:create, :update, :index]
    resources :teams, except: [:new, :edit, :index]
    resources :organisations, except: [:new, :edit] do
      get :users, on: :collection
      put :current, on: :member
    end
    resources :assignments, only: [:create, :destroy]
    resources :memberships, only: [:create, :destroy]
    resources :invitations, only: [:index, :create, :destroy]
    resources :atoms, only: [:create, :index, :show] do
      collection do
        put :update
        delete :destroy
      end
      resource :permission, only: [:show] do
        post :set
      end
    end
    resources :roles, only: [:index]
    resources :settings, only: [:update]
    resources :emails, only: [:create]
    resources :jobs, only: [:create, :show, :destroy]
    resources :projects, only: [:create]
  end
end
