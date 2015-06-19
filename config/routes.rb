require 'sidekiq/web'

Rails.application.routes.draw do
  root :to => 'home#index'

  devise_for :users, :controllers => {
      :registrations => 'users/registrations',
      :passwords     => 'users/passwords'
    }

  get 'teams' => 'teams#index', as: :user_root

  authenticate :user, lambda { |u| u.email == "davekaro@gmail.com" || u.email == "bhandari.sudershan@gmail.com" } do
    mount Sidekiq::Web => '/sidekiq'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  namespace :admin do
    resources :users, :only => [:index] do
      collection do
        get :test_raven
      end
      member do
        get :become
      end
    end
  end

  resources :teams, :except => [:show] do
    resources :practices do
      member do
        get :availability_email
        get :availabilities
      end
    end
    resources :matches do
      member do
        get :availabilities
        get :availability_email
        get :player_request_email
        get :lineup_email
      end
      collection do
        get :import
        post :perform_import
      end
    end
    # TODO Delete these routes 7 days later
    resources :match_availabilities, :only => [] do
      collection do
        get :set_availability
      end
    end
    # TODO Delete these routes 7 days later
    resources :practice_sessions, :only => [] do
      collection do
        get :set_availability
      end
    end
    resources :responses, :only => [:index] do
      collection do
        get :set_availability
      end
    end
    resources :results, :only => [:index]
    resources :team_members, :only => [:index, :edit, :update, :destroy] do
      collection do
        get 'new', as: :new
        post 'create', as: :create
      end
      member do
        post 'send_welcome_email'
      end
    end
    member do
      post 'send_welcome_email'
    end
  end

  resources :practices, :only => [] do
    resources :responses, :only => [:create, :update]
    member do
      post 'notify'
    end
  end

  resources :matches, :only => [] do
    resources :responses, :only => [] do
      member do
        post :save_availability
        post :save_note
      end
    end
    member do
      post 'notify'
      post 'notify_player_request'
      post 'notify_lineup'
      get 'edit_lineup' => 'match_lineups#edit'
      get 'edit_results' => 'results#edit'
    end
  end

  resource :change_password, :only => [:edit, :update] do
    member do
      get 'send_reset'
    end
  end

  namespace :api do
    post 'postmark/inbound' => 'postmark#inbound'
    post 'postmark/bounce'  => 'postmark#bounce'
  end
end
