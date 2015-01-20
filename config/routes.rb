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

    resources :members do
      get "edit_member" => "admins#edit_member", as: :edit_member
      patch "update_member" => "admins#update_member", as: :update_member
    end
  end

  resources :events do
    resources :products

    resources :shopping_carts do
      get "search" => "shopping_carts#search", as: :search
      resources :cart_items

      collection do
        post :add_to_cart
      end
    end
  end

  resources :members, except: [:create, :edit]
  resources :shopping_carts, only: [:show]
  resources :teams
  resources :team_members, only: [:new, :destroy]
  resources :vendors

  post "create_member" => "members#create", as: :create_member
  get "member/edit_account" => "members#edit_account", as: :edit_account
  get "my_account" => "dashboards#index", as: :my_account
  get "shopping_cart_history" => "shopping_carts#history", as: :shopping_cart_history
  # root to: "pages#index"
  root to: "dashboards#index"
end
