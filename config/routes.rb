Rails.application.routes.draw do
  #get 'filters/index'
  #get 'filters/show'
  #get 'filters/new'
  #get 'filters/create'
  #get 'filters/edit'
  #get 'filters/update'
  #get 'filters/destroy'
  resources :filters

  root                 'static_pages#home'
  get     'help'    => 'static_pages#help'
  get     'about'   => 'static_pages#about'
  get     'signup'  => 'users#new'
  get     'login'   => 'sessions#new'
  post    'login'   => 'sessions#create'
  delete  'logout'  => 'sessions#destroy'

  get     'print/all'         => 'output_pages#all',      as: :print
  get     'print/cards'       => 'output_pages#cards',    as: :print_cards
  get     'print/spells'      => 'output_pages#spells',   as: :print_spells
  get     'print/items'       => 'output_pages#items',    as: :print_items
  get     'print/monsters'    => 'output_pages#monsters', as: :print_monsters

  get     'cards/:id/modal'       => 'cards#modal'
  get     'items/:id/modal'       => 'items#modal'
  get     'monsters/:id/modal'       => 'monsters#modal'
  get     'spells/:id/modal'       => 'spells#modal'

  patch     'cards/:id/preview'     => 'cards#preview'
  patch     'items/:id/preview'     => 'items#preview'
  patch     'monsters/:id/preview'  => 'monsters#preview'
  patch     'spells/:id/preview'    => 'spells#preview'

  namespace :admin do
    root                      'admin#home',     as: :admin
    get     'import'       => 'card_imports#new'
    get     'export'       => 'card_imports#index'
    delete  'card_imports' => 'card_imports#destroy'
    resources :card_imports
  end

  post      'cards/:id/duplicate'         =>  'cards#duplicate',      as: :duplicate_card
  post      'items/:id/duplicate'         =>  'items#duplicate',      as: :duplicate_item
  post      'monsters/:id/duplicate'      =>  'monsters#duplicate',   as: :duplicate_monster
  post      'spells/:id/duplicate'        =>  'spells#duplicate',     as: :duplicate_spell

  resources :users
  resources :spells
  resources :hero_classes
  resources :items
  #resources :items, controller: 'cards', type: 'Item'
  resources :monsters
  resources :cards
  #resources :cards, controller: 'cards', type: 'Card'
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
