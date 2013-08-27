Km7::Application.routes.draw do
devise_for :users
#devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }

resources :problems
resources :users
resource :user, only: [:show] do
  collection do
    put 'update_password'
    #Only works in Rails master branch
    #patch 'update_password'
  end
end

resources :lists do
  member do
    put "add_problem_list:problem_id", action: :add_problem, as: :add_problem
    delete "remove_problem_list/:problem_id", action: :remove_problem, as: :remove_problem
  end
end

#get "prob_comment/create"
#get "prob_comment_controller/create"

  match '/new_user',  to: 'users#new'
  match '/users', to: 'users#index'
  match '/edit_user', to: 'users#edit'
  

  match '/reports', to: 'problems#index'
  match '/report', to: 'problems#new'

  match '/lists', to: 'lists#index'
  match '/new_list', to: 'lists#new'

  devise_scope :user do
  root to: "devise/sessions#new"
  end

  match '/help',    to: 'static_pages#help'
  match '/about_us',   to: 'static_pages#about'
  match '/contact_us', to: 'static_pages#contact'
  match '/dashboard', to: 'static_pages#admin_dashboard'

  match "/problems/add_new_comment" => "problems#add_new_comment", :as => "add_new_comment_to_problems", :via => [:post]
  match "/problems/:id/delete_comment" => "problems#delete_comment", :as => "delete_comment_from_problems", :via => [:delete]


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
