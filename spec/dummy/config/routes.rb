Rails.application.routes.draw do
  resources :precs
  root 'parent_records#index'
  get '/parent_records/new/:approval_flag(/:email_detail_cb_flag)', to: 'parent_records#new'
  resources :parent_records
  mount NdApplicationWorkflow::Engine => "/nd_application_workflow"
end
