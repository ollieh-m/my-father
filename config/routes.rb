Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :parts, only: [] do
      resources :sections, only: [:index, :create, :edit, :update]
    end
  end

  resources :parts, only: [] do
    resources :sections, only: [:show]
  end

end
