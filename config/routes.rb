Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => "standard/abouts#show"

  namespace :admin do
    resources :parts, only: [] do
      namespace :sections do
        resource :order, only: [:update]
      end

      resources :sections, only: [:index, :create, :edit, :update]
    end
  end

  scope module: :standard do
    resources :parts, only: [] do
      resources :sections, only: [:show, :index]
    end
    resource :about, only: [:show]
  end

  resources :sessions, only: [:new, :create, :destroy]

end
