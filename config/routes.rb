Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :books, only: [:index] do
    member do
      patch :check_out
      patch :check_in
    end
  end

  root "books#index"
end
