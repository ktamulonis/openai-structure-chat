Rails.application.routes.draw do
  resources :messages

  resources :chats do
    member do
      get :edit_schema
      patch :update_schema
    end
  end

  # Health/PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  #
  # === Structured Schemas & Fields ===
  #
  resources :structured_schemas do
    member do
      get  :edit_fields
      patch :update_fields
    end

    post :run, on: :member

    resources :structured_fields, path: "fields", controller: "structured_fields", only: %i[create destroy] do
      collection do
        patch :reorder
      end
    end
  end
  #
  # Legacy update_schema route (still used by the chat select)
  #
  patch "chats/:id/schema",
        to: "chats#update_schema",
        as: :chat_schema

  #
  # Root
  #
  root "chats#index"
end
