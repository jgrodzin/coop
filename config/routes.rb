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
      patch "archive_member" => "admins#archive_member", as: :archive_member
      patch "activate_member" => "admins#activate_member", as: :activate_member
      collection do
        get :archives
      end
    end

    resources :vendors do
      patch "archive_vendor" => "admins#archive_vendor", as: :archive_vendor
      patch "activate_vendor" => "admins#activate_vendor", as: :activate_vendor
      collection do
        get "archives" # => "admins#vendor_archives", as: :archives
      end
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

  resources :members, except: [:create, :edit] do
    get "member/edit_account" => "members#edit_account", as: :edit_account
  end
  resources :shopping_carts, only: [:show]
  resources :teams
  resources :team_members, only: [:new, :destroy]
  resources :vendors

  post "create_member" => "members#create", as: :create_member
  get "my_account" => "dashboards#index", as: :my_account

  root to: "pages#index"
end
