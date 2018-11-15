BeachApiCore::Engine.routes.draw do
  use_doorkeeper

  namespace :admin do
    get "endpoints/models"
    get "endpoints/actions"
    get "endpoints/entities"
    get "endpoints/handlers"
    resources :preview_auth, only:[:show]
    get "redirect" => "redirect#index"
  end

  api_version(module: 'V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
    resources :uploads
    resources :devices
    resources :applications, except: %i(new edit)
    resources :mail_bodies
    post "/applications/:id/upload_logo_image", :to => "applications#upload_logo_image"
    resources :sessions, only: [:create, :destroy], path: :auth
    resources :favourites, only: %i(index create destroy)
    resources :entities, only: %i(show create destroy) do
      resources :messages, only: %i(index create update destroy), controller: 'entity_messages'
      get :lookup, on: :collection
    end
    resources :webhooks, only: %i(index create destroy)
    get "/users/success", :to => "users#success", defaults: { format: false }
    get "/users/:id/activate_account/:confirmation_token", :to => "users#activate_account", defaults: { format: false }
    put '/users/confirm_user/:id', :to => 'users#force_confirm_user'
    resources :users, only: %i(create index) do
      post :confirm, on: :member, defaults: { format: false }
    end
    resource :password, only: %i(create update), defaults: { format: false }
    get "/password/restore_password/:token", to: "passwords#restore_password",  defaults: { format: false }
    get "/password/success", to: "passwords#success_restore",  defaults: { format: false }
    resource :user, only: %i(show update)
    resources :services, only: %i(index update) do
      resource :capabilities, only: %i(create destroy)
    end
    resources :service_categories, only: %i(create update index)
    resources :teams, except: %i(new edit)
    resources :organisations, except: %i(new edit) do
      collection do
        get :users
        get :get_current
      end
      put :current, on: :member
    end
    resources :assignments, only: %i(create destroy)
    resources :user_accesses, only: %i(create destroy)
    resources :memberships, only: %i(create destroy)
    resources :invitations, only: %i(index create destroy) do
      match :accept, on: :member, via: [:get, :post],  defaults: { format: false }
      match :accept_invitation, on: :member, via: [:get],  defaults: { format: false }
      get :success, on: :member, defaults: {format: false}
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
    resources :interactions, only: %i(create)
    resources :channels, only: %i(index)
    resources :chats, only: %i(index create) do
      put :add_recipient, on: :member
      put :read, on: :member
      resources :messages, only: %i(create index)
    end
  end
end
