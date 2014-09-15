IpadTracking::Application.routes.draw do
  devise_for :users
  root to: "welcome#index"
  resources :students
  resources :devices
  resources :notes
  resources :finances
  resources :admins

  get "/show/meraki/:serial", to: "devices#meraki", as: "meraki"

  get "/deassociate/:id", to: "devices#deassociate", as: "deassociate"
  get "/associate/:id", to: "devices#associate", as: "associate"

  get "/device/:id/check_in", to: "devices#check_in", as: "device_check_in"
  get "/device/:id/check_out", to: "devices#check_out", as: "device_check_out"

  post "/admin/import_all_submit", to: "admins#import_all_submit", as: "import_all_submit"
  get "/admin/import_all", to: "admins#import_all", as: "import_all"
  get "/admin/edit_admins", to: "admins#edit_admins", as: "edit_admins"
  post "/admin/update_admins", to: "admins#update_admins", as: "update_admins"
  get "/admin", to: "admins#index", as: "administrator"
  get "/admin/logs", to: "admins#logs", as: "admin_logs"
  get "/admin/export_students", to: "admins#export_students", as: "admin_export_students"

  

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
