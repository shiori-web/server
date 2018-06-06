Rails.application.routes.draw do
  use_doorkeeper

  get 'confirm' => 'registrations#show'

  jsonapi_resources :users
end
