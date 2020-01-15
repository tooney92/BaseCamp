Rails.application.routes.draw do
  resources :users do
    get "login", :on => :collection
    get "logout", :on => :collection
    get "delete/:user_id" => 'users#delete', :on => :collection
    post "login" => 'users#login_user', :on => :collection
    get "dashboard" => 'users#dashboard', :on => :collection 
    get "profile" => 'users#profile', :on => :collection
    get "allusers" => 'users#allusers', :on => :collection
    resources :projects 
  end
 
  root "users#index"
end
