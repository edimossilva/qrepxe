Rails.application.routes.draw do
  resources :answers_collection, only: %i[create]
end
