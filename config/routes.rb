Rails.application.routes.draw do
  devise_for :admins
  devise_for :members, skip: [:registrations]
  as :member do
    get "members/edit" => "devise/registrations#edit", as: "edit_member_registration"
    patch "users/:id" => "devise/registrations#update", as: "member_registration"
  end

  resources :admins do
    collection do
      get :products
      get :teams
    end
  end

  resources :events do
    resources :products

    resources :shopping_carts do
      resources :cart_items

      collection do
        post :add_to_cart
      end
    end
  end

  resources :members, except: :create
  resources :teams
  resources :team_members, only: [:new, :destroy]
  resources :vendors

  # resources :cart_history, controller: "shopping_cart/cart_history", only: [:index, :show]
  post "create_member" => "members#create", as: :create_member
  get "my_account" => "accounts#index", as: :my_account
  root to: "pages#index"
end
