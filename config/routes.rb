Rails.application.routes.draw do

  devise_for :admins
  devise_for :members

  root "welcome#index"

  resources :events do
    resources :products do

    end
    resources :shopping_carts do
      resources :cart_items
      collection do
        post :add_to_cart
      end
    end
  end

  resources :admins
  resources :cart_history, controller: "shopping_cart/cart_history", only: [:index, :show]
  resources :members
  resources :teams
  resources :vendors
end
