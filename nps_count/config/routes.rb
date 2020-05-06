Rails.application.routes.draw do
  resources :answers_collection, only: %i[create]
  resources :nps, only: %i[index]
  resources :nps_report, only: %i[index]
  resources :answers_count, only: %i[index]
end
