Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :admins

  mount_devise_token_auth_for 'User', at: 'api/v1/auth'
  as :user do
    namespace :api, except: [:new, :edit], defaults: { format: 'json' } do
      namespace :v1 do
        resources :cards, only: [:index, :create, :destroy]
        resources :categories, except: [:destroy, :update, :create]
        resources :products, except: [:destroy, :update, :create]
        resources :shipping_points, except: [:destroy, :update, :create]
        resource :cart do
          collection do
            patch :process_order
            patch :set_address
            patch :set_card
          end
        end
        resources :shipping_addresses, only: [:index, :create, :destroy]
        resource :users, only: [] do
          collection do
            get :current
            post :create_card
          end
        end
      end
    end
  end

  root to: 'rails_admin/main#dashboard'
end
