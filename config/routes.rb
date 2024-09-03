Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#login'
  root 'course#index'
  resources :users
  # resources :grades, only: [:create,:index,:show]#added show while teacher can see grades of student they own
  resources :grades
  resources :enrollments, only: [:index, :create, :update, :show, :destroy]#added for tecaher chekcing
  # resources :enrollments, only: [:index,:destroy]#commented while checking for teacher
  delete 'auth/logout', to: 'authentication#logout'
  resources :courses do
    resources :enrollments
  end
end
