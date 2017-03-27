BeachApiCore::Engine.routes.draw do
  use_doorkeeper

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: 'json' } ) do
    resources :applications, only: [:index, :create, :show, :update, :destroy]
    resources :sessions, only: :create, path: :auth
    resources :favourites, only: [:index, :create, :destroy]
    resources :users, only: [:create]
    resource :user, only: [:show, :update]
    resources :services, only: [:index, :update] do
      resource :capabilities, only: [:create, :destroy]
    end
    resources :service_categories, only: [:create, :update, :index]
    resources :teams, only: [:show, :create, :update, :destroy]
    resources :organisations, except: [:new, :edit] do
      get :users, on: :collection
      put :current, on: :member
    end
    resources :memberships, only: [:create, :destroy]
    resources :invitations, only: [:index, :create, :destroy]
    resources :atoms, only: [] do
      resources :permission, only: [:index]
    end
    resources :roles, only: [:index]
  end
end
