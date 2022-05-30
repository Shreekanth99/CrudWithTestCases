Rails.application.routes.draw do
  namespace :api do
    resources :user, :except => [:index]
    get 'users', to: 'user#index'
    get 'typeahead/:input', to: 'user#typeahead'
  end
end
