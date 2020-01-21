Rails.application.routes.draw do
  resources :users do
    get "login", :on => :collection
    get "logout", :on => :collection
    get "delete/:user_id" => 'users#delete', :on => :collection
    get "makeadmin/:id" => 'users#make_admin', :on => :collection
    post "login" => 'users#login_user', :on => :collection
    get "dashboard" => 'users#dashboard', :on => :collection 
    get "profile" => 'users#profile', :on => :collection
    get "allusers" => 'users#allusers', :on => :collection
    resources :projects
    
  end
  get "/projects/:project_id/topic/:topic_id", :to => 'projects#show_topic', :method => 'get'
  get "/projects/:project_id/topic/:topic_id/edit", :to => 'projects#edit_topic', :method => 'get'
  post "/:user_id/projects/:project_id/topic/new", :to => 'projects#new_topic', :method => 'post'
  put "/projects/:project_id/topic/:topic_id", :to => 'projects#update_topic', :method => 'put'
  delete "/projects/:project_id/topic/:topic_id", :to => 'projects#delete_topic', :method => 'delete'
  post "/projects/:project_id/topic/:topic_id/messages/new", :to => 'projects#new_message', :method => 'post'
  root "users#index"
end

