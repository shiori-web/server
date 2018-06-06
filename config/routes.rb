Rails.application.routes.draw do
  use_doorkeeper

  get 'confirm' => 'registrations#show'

  namespace :api do
    resources :users, except: [:new, :edit]
  end
end
