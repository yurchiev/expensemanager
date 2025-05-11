Rails.application.routes.draw do
  root to: "expenses#index"  # Головна сторінка, яка показує витрати

  post "expenses/add", to: "expenses#create"  # Додавання витрати
  post "expenses/edit", to: "expenses#update"  # Оновлення витрати
  post "expenses/delete", to: "expenses#destroy"  # Видалення витрати
  get "expenses/search", to: "expenses#search"  # Пошук витрат
  get "expenses/save-json", to: "expenses#save_json"  # Зберегти витрати в JSON
  get "expenses/save-yaml", to: "expenses#save_yaml"  # Зберегти витрати в YAML
  get "expenses/load-json", to: "expenses#load_json"  # Завантажити витрати з JSON
  get "expenses/load-yaml", to: "expenses#load_yaml"  # Завантажити витрати з YAML

  get "up" => "rails/health#show", as: :rails_health_check  # Перевірка стану сервера
end
