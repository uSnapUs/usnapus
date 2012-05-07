Usnapus::Application.routes.draw do

  mount Resque::Server.new, :at => "/resque"
  
  devise_for :users, :controllers => { :registrations => 'registrations' }
  
  root to: "home#index"
  get "geocode_search", to: "home#geocode_search"
  
  resources :devices, only: [:create, :update]

  resources :events, except: [:delete] do
    member do
      get :upgrade
    end
    resources :photos, except: [:update, :edit] do
      collection do
        get :fullscreen
        get :download
      end
    end
    resources :purchases, only: [:new, :create]
  end
  
  

  match "welcome/:path", to: "landing_pages#show"
  match "this_is_a_test/billing", to: "events#billing_test"

  resources :signups, only: [:create]
  
  match "notifier/:action", :controller => "notifier"
  post "postmark/:token/inbound_emails", to: "inbound_emails#create"
  
  
  #Keep at the end
  get "/terms_of_use", to: "home#terms_of_use"
  get "/privacy_policy", to: "home#privacy_policy"
  get ':code/fullscreen', :to=> "photos#fullscreen"
  get ':code', :to=> "photos#index"
  
end
