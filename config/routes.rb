# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :quizzes, only: %i[new create show] do
    resource :question, only: %i[show] do
      collection do
        post :buzz
        post :next
      end
    end

    resources :answers, only: %i[index show] do
      post :call_fastest_player, on: :collection

      member do
        post :correct
        post :incorrect
      end
    end

    member do
      post :join
      post :start
      post :end
    end
  end


end
