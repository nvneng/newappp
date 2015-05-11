Rails.application.routes.draw do
  get 'search/artist'

  get 'history/get'

  devise_for :users
  root to: 'visitors#index'
end
