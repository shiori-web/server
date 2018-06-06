Rails.application.routes.draw do
  use_doorkeeper

  get 'confirm' => 'confirmations#show'

  jsonapi_resources :users
end
