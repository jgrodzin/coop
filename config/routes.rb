Rails.application.routes.draw do

  devise_for :admins
  devise_for :members, skip: [:registrations]
  as :member do
    get "members/edit" => "devise/registrations#edit", as: "edit_member_registration"
    put "users" => "devise/registrations#update", as: "member_registration"
  end
  resources :members, except: :create
  post "create_member" => "members#create", as: :creaet_user

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

  resources :admins do
    collection do
      get :products
      get :teams
    end
  end

  resources :cart_history, controller: "shopping_cart/cart_history", only: [:index, :show]
  post "create_member" => "members#create", as: :create_member
  resources :teams
  resources :team_members, only: [:new, :destroy]
  resources :vendors

  root to: "pages#index"
end
