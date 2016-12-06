Rails.application.routes.draw do
  resources :precs
  root 'parent_records#index'
  resources :parent_records
  mount NdApplicationWorkflow::Engine => "/nd_application_workflow"
end
