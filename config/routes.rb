Rails.application.routes.draw do
  root to: "standard/landings#show"

  namespace :admin do
    root to: "landings#show"
    resources :parts, only: [] do
      namespace :sections do
        resource :order, only: [:update]
      end
      resources :sections, only: [:index, :create, :edit, :update, :destroy]
    end
  end

  scope module: :standard do
    resources :parts, only: [:show] do
      resources :sections, only: [:show, :index]
    end
    resource :about, only: [:show]
    resource :landing, only: [:show]
  end

  resources :sessions, only: [:new, :create, :destroy]
end
