Rails.application.routes.draw do
  get "home/index"
  
  # Custom Devise routes with overridden registrations controller
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  
  # Letter Opener Web - Email inbox interface (development only)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  # Waiting for consent page for underage users
  get "waiting_for_consent", to: "waiting_for_consent#index"
  post "waiting_for_consent/resend", to: "waiting_for_consent#resend_email", as: :resend_consent_email
  
  # Parental consent approval
  get "consent/:token", to: "parental_consents#approve", as: :approve_consent
  
  # Dashboard for authenticated users
  get "dashboard", to: "dashboard#index"
  
  # Activities/Participation Areas for authenticated users
  resources :participation_areas
  
  # Admin panel for organization management
  namespace :admin do
    resources :organizations, only: [:index, :show, :new, :create] do
      member do
        patch :update_member_role
      end
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Conditional root routes based on authentication
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'home#index'
  end
end
