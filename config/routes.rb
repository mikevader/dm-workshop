Rails.application.routes.draw do
  root                 'static_pages#home'
  get     'help'    => 'static_pages#help'
  get     'about'   => 'static_pages#about'
  get     'signup'  => 'users#new'
  get     'login'   => 'sessions#new'
  post    'login'   => 'sessions#create'
  delete  'logout'  => 'sessions#destroy'

  get     'print/cards'       => 'output_pages#cards',    as: :print_cards
  get     'print/spells'      => 'output_pages#spells',   as: :print_spells
  get     'print/items'       => 'output_pages#items',    as: :print_items
  get     'print/monsters'    => 'output_pages#monsters', as: :print_monsters

  patch     'cards/:id/preview'     => 'cards#preview'
  patch     'items/:id/preview'     => 'items#preview'
  patch     'monsters/:id/preview'  => 'monsters#preview'
  patch     'spells/:id/preview'    => 'spells#preview'

  namespace :admin do
    root                  'admin#home',     as: :admin
    get     'import'   => 'card_imports#new'
    get     'export'   => 'card_imports#index'
    resources :card_imports
  end

  post      'monsters/:id/duplicate'      =>  'monsters#duplicate',    as: :duplicate_monster

  resources :users
  resources :spells
  resources :hero_classes
  resources :items
  resources :monsters
  resources :cards
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  mount RailsAdmin::Engine => '/super_admin', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
