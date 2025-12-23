Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do 
      post '/login', to: "auth#login"

      resources :users, only: [:create]
      resources :courses, only: [:index, :create, :update, :show]
      resources :schools, only: [:index, :show, :create, :update]
      resources :batches, only: [:index, :show, :create, :update] do 
         member do
          get :students
        end
      end

      resources :enrollments, only: [:create] do
        member do
          patch :approve
          patch :reject
        end
      end
    end
  end
end
