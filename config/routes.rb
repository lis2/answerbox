Answerbox::Application.routes.draw do

  devise_for :users,:skip => [:sessions,:confirmations,:passwords,:registrations],:controllers => {:omniauth_callbacks => "users/omniauth_callbacks",:sessions => "sessions"} do
    get '/logout' => 'sessions#destroy', :as => :destroy_user_session
    get "/login"  => "sessions#login"  , :as => :login_user_session
  end

  devise_scope :user do
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  resources :questions, only: [:show, :index, :new, :create] do
    resources :answers, only: [:new, :create] do
      post :mark_as_checked, on: :member
    end
  end

  root :to => "questions#index"
end
