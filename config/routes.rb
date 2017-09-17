Rails.application.routes.draw do
  root 'platforms#index'

  resources :platforms do
    member do
      get 'update_all_markets'
    end
    resources :markets
  end

  resources :markets do
    resources :tickers
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
end
