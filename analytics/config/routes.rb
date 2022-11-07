Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  post 'transactions', to: 'transaction#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
