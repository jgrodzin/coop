Rails.application.routes.draw do
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
      patch "archive" => "admins#archive_member", as: :archive
    end
  end

  resources :events do
    resources :products
    resources :shopping_carts do
      resources :cart_items

      collection do
        get :history
      end

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

  root to: "pages#index"
end
