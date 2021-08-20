Rails.application.routes.draw do
  root 'main_editor#index'

  get '/index', to: 'main_editor#index'
  get '/preprocess', to: 'main_editor#preprocess'
end
