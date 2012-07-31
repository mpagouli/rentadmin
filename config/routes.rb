Rentadmin::Application.routes.draw do

  get "timeline/timeline"

  get "reservations/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
  resources :users
  resources :makes do
    resources :models
  end
  resources :models do
      resources :vehicles
      resources :assets
  end
  resources :groups do
    resources :models
  end
  resources :reservations do
    resources :vehicles
  end
  resources :vehicles do
    resources :reservations
  end
  resources :asset_categories do
    resources :assets
  end
  resources :sessions, only: [:new, :create, :destroy]

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root to: 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  match '/home', to: 'static_pages#home'
  match '/help', to: 'static_pages#help'

  match '/timeline', to: 'timeline#timeline'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
  match '/admin', to: 'menu_pages#admin'
  match '/operation', to: 'menu_pages#operation'
  match '/board', to: 'menu_pages#board'

  #Ajax
  match '/filter_models', to: 'vehicles#filter_models'
  match '/savemake', to: 'makes#savemake'
  match '/makeopen', to: 'makes#makeopen'
  match '/makemodify', to: 'makes#makemodify'
  match '/dropmake', to: 'makes#dropmake'
  match '/savemodel', to: 'models#savemodel'
  match '/modelopen', to: 'models#modelopen'
  match '/modelmodify', to: 'models#modelmodify'
  match '/dropmodel', to: 'models#dropmodel'
  match '/book_vehicle', to: 'reservations#book_vehicle'
  match '/show_duration', to: 'reservations#show_duration'
  match '/check_booked_dates', to: 'reservations#check_booked_dates'
  match '/timeline_ajax', to: 'timeline#timeline_ajax'


end
