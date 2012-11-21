Answerbox::Application.routes.draw do

  devise_for :users,:skip => [:sessions,:confirmations,:passwords,:registrations],:controllers => {:omniauth_callbacks => "users/omniauth_callbacks",:sessions => "sessions"} do
    get '/logout' => 'sessions#destroy', :as => :destroy_user_session
    get '/login' => 'sessions#new', :as => :new_user_session
  end

  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end



  resources :questions, only: [:show, :index, :new, :create] do
    resources :answers, only: [:new, :create]
    collection do
      post :filter
    end
  end

  resources :answers do
    post :mark_as_checked, on: :member
  end

  resources :tags, only: [:index]

  root :to => "questions#index"
end
