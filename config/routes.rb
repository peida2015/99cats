Rails.application.routes.draw do
  root to: 'cats#index'
  resources :cats, only: [:index, :show, :new, :create, :update, :edit] do
    resources :cat_rental_requests, only: [:index]
  end
  resources :cat_rental_requests, only: [:show, :new, :create, :update, :edit] do
    member do
      patch 'approve', to: "cat_rental_requests#approve"
      patch 'deny', to: "cat_rental_requests#deny"
    end
  end
  # patch "/cat_rental_requests/:id", to: "cat_rental_requests#approve"
  # patch "/cat_rental_requests/:id", to: "cat_rental_requests#deny"
end
