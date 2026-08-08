Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :books, only: [:index] do
    member do
      patch :check_out
      patch :check_in
    end
  end

  root "books#index"
end
