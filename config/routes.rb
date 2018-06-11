Rails.application.routes.draw do
  use_doorkeeper

  get 'confirm' => 'confirmations#show'

  jsonapi_resources :animes
  jsonapi_resources :casts
  jsonapi_resources :characters
  jsonapi_resources :producers
  jsonapi_resources :anime_producers
  jsonapi_resources :genres
  jsonapi_resources :people
  jsonapi_resources :staffs
  jsonapi_resources :tags
  jsonapi_resources :users
end
