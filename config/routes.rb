Rails.application.routes.draw do
  # get 'line/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "webhooks/:source", to: "line#create", as: :line_webhook

end
