Rails.application.routes.draw do
  devise_for :people, controllers: { sessions: 'sessions' }
  resources :statuses
  resources :student_classes
  resources :people
  resources :promotion_asserts
  resources :grades
  resources :students do
    member do
      get :generate_report
    end
  end
  resources :examinations do
    member do
      get 'students_with_grades', to: 'examinations#students_with_grades'
      post 'save_grades', to: 'examinations#save_grades'
    end
  end
  resources :courses do
    collection do
      get :calendar
    end
  end
  resources :school_classes do
    collection do
      get 'by_year_moment/:year_moment_id', to: 'school_classes#by_year_moment', as: :by_year_moment
      get 'by_moment/:moment_id', to: 'school_classes#by_moment', as: :by_moment
    end
    member do
      get 'details', to: 'school_classes#get_class_details', as: :details
      get 'students', to: 'school_classes#students', as: :students
      get 'courses', to: 'school_classes#courses', as: :courses
      get 'grades', to: 'school_classes#grades', as: :grades
      get 'teachers', to: 'school_classes#teachers', as: :teachers
      post 'add_student', to: 'school_classes#add_student', as: :add_student
      post 'add_course', to: 'school_classes#add_course', as: :add_course
      post 'add_examination', to: 'school_classes#add_examination', as: :add_examination
    end
  end
  resources :subjects
  resources :moments do
    collection do
      get 'get_year_for_moment/:moment_id', to: 'moments#get_year_for_moment', as: :get_year_for_moment
    end
  end
  resources :sectors
  resources :rooms
  resources :addresses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
