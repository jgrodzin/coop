Rails.application.routes.draw do

  devise_for :members

  root "welcome#index"

  resources :events do
    resources :products do
      collection do
        post :add_to_cart
      end
    end

    resources :shopping_carts do
      resources :cart_items
    end
  end
  resources :members
  resources :teams
  resources :vendors

end
