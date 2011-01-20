Nsbe::Application.routes.draw do
  
  resources :zones
  resources :position_members
  resources :positions
  resources :announcements
  resources :registrations
  resources :users
  resource :session, :only => [:new, :create, :destroy]
  resources :events
  
  
  # User related routes
  match 'signup' => 'users#new', :as => :signup
  match 'register' => 'users#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'my_account' => 'users#my_account', :as => :my_account
  match 'show_profile/:id' => 'users#show_profile', :as => :show_profile, :id => nil
  match 'edit/my_account' => 'users#edit', :as => :edit_my_account
  match 'change_password' => 'users#change_password', :as => :change_password
  match 'reset_password' => 'users#reset_password', :as => :reset_password
  match '/activate/:activation_code' => 'users#activate', :as => :activate, :activation_code => nil
  
  # Home Related Routes
  root :to => 'home#index'
  match 'home' => 'home#index', :as => :home
  match 'directory' => 'home#directory', :as => :directory
  match 'chapter' => 'home#chapter', :as => :chapter
  match 'contact' => 'home#contact', :as => :contact
  match 'about' => 'home#about', :as => :about
  match 'my_events' => 'home#my_events', :as => :my_events

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
