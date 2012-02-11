Usnapus::Application.routes.draw do
  
  devise_for :users
  
  root to: "home#index"

  resources :devices, only: [:create, :update]

  resources :events, only: [:index, :show] do
    resources :photos, except: [:update, :edit] do
      collection do
        get :fullscreen
      end
    end
  end

  resources :signups, only: [:create]
  
  #Keep at the end
  get '*code', :to=> "events#show"
  
end
