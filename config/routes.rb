Usnapus::Application.routes.draw do
  
  mount Resque::Server.new, :at => "/resque"
  
  devise_for :users
  
  root to: "home#index"
  get "geocode_search", to: "home#geocode_search"
  
  resources :devices, only: [:create, :update]

  resources :events, only: [:new, :index, :show] do
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
