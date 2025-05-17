Rails.application.routes.draw do
  root to: "expenses#index"

  post "expenses/add", to: "expenses#create"
  post "expenses/edit", to: "expenses#update"
  post "expenses/delete", to: "expenses#destroy"
  get "expenses/search", to: "expenses#search"
  get "expenses/save-json", to: "expenses#save_json"
  get "expenses/save-yaml", to: "expenses#save_yaml"
  get "expenses/load-json", to: "expenses#load_json"
  get "expenses/load-yaml", to: "expenses#load_yaml"

  get "up" => "rails/health#show", as: :rails_health_check
end
