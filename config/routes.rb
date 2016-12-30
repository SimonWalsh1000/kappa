Rails.application.routes.draw do

  resources :users do
    collection do
      get :data
      get :upload
      get :university
      post :import
      get :export_comparisons
    end
  end

  resources :clinicians do
    collection do
      get :upload
      post :import
      get :breakdown
    end
  end

  resources :survivals do
    collection do
      get :results
      get :results_breakdown
      get :countries_survival
      get :upload
      post :import
    end
  end

  resources :scores do
    collection do
      get :authors
      get :countries_kappa
      get :countries_demo
      get :nuclear
      get :upload
      get :excel
      get :analysis
      get :multiple_kappas
      post :multiple_kappas
      post :import
      post :search
      post :test
      get :discrepancy
      get :export
      get :export_ipf
      get :export_adjusted_ipf
      get :ipf
      get :ipf_adjusted
      get :export_diagnosis
      get :diagnosis
      get :management
      get :experience
      get :completed_breakdown
      get :all_kappas
      get :ipf_agreement
      get :confidence
      get :confidence_download
      get :number_of_ipf_diagnoses
      get :number_of_ipf_diagnoses_wk
      get :number_of_high_confidence_ipf_diagnoses
      get :number_of_high_confidence_ipf_diagnoses_wk
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'scores#analysis'

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
