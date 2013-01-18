Km7::Application.routes.draw do
resources :problems
resources :users
resources :comments
resources :sessions, only: [:new, :create, :destroy]
resources :lists do
  member do
    put "agregar_reporte/:problem_id", action: :add_problem, as: :add_problem
    delete "remover_reporte/:problem_id", action: :remove_problem, as: :remove_problem
  end
end

#get "prob_comment/create"
#get "prob_comment_controller/create"

  match '/crear_usuario',  to: 'users#new'
  match '/usuarios', to: 'users#index'
  match '/editar', to: 'users#edit'
  
  match '/registrar',  to: 'sessions#new'
  match '/salir', to: 'sessions#destroy', via: :delete

  match '/reportes', to: 'problems#index'
  match '/reportar', to: 'problems#new'

  match '/listas', to: 'lists#index'
  match '/crear_lista', to: 'lists#new'
  match '/ver_reportes', to: 'lists#show_problems'
  
  root to: 'static_pages#home'

  match '/ayuda',    to: 'static_pages#help'
  match '/nosotros',   to: 'static_pages#about'
  match '/contacto', to: 'static_pages#contact'  

  match "/problems/add_new_comment" => "problems#add_new_comment", :as => "add_new_comment_to_problems", :via => [:post]
  #match "/problems/remove_comment" => "problems#remove_comment", :as => "remove_comment_to_problems", :via => [:delete]

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
