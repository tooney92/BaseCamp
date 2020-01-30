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
    get "/shared_projects" => 'projects#shared_projects', :on => :collection
    resources :projects do
      get "add_users/index", :to => 'projects#myusers_project'
      post "add_user", :to => 'projects#add_user'
      delete "delete_user", :to => 'projects#destroy_user'
      get "add_task", :to => 'projects#mytasks_project'
      post "add_task/new", :to => 'projects#addtasks_project'
      get "add_task/index", :to => 'projects#alltasks_project'
      get "edit_task/:task_id", :to => 'projects#edit_task'
      put "edit_task/:task_id", :to => 'projects#update_task'
      delete "delete_task/:task_id", :to => 'projects#destroy_task'

    end
    
  end
  get "/projects/:project_id/topic/:topic_id", :to => 'projects#show_topic', :method => 'get'
  get "/projects/:project_id/topics/index", :to => 'projects#index_topic'
  post "/:user_id/projects/:project_id/topic/new", :to => 'projects#new_topic', :method => 'post'
  get "/projects/:project_id/topic/:topic_id/edit", :to => 'projects#edit_topic', :method => 'get'
  put "/projects/:project_id/topic/:topic_id", :to => 'projects#update_topic', :method => 'put'
  delete "/projects/:project_id/topic/:topic_id", :to => 'projects#delete_topic', :method => 'delete'
  delete "/projects/:project_id/image/:image_id", :to => 'projects#delete_image', :method => 'delete'
  post "/projects/:project_id/topic/:topic_id/messages/new", :to => 'projects#new_message', :method => 'post'
  get "/projects/:project_id/topic/:topic_id/messages/:message_id/edit", :to => 'projects#edit_message'
  put "/projects/:project_id/topic/:topic_id/messages/:message_id", :to => 'projects#update_message', :method => 'put'
  delete "/projects/:project_id/topic/:topic_id/messages/:message_id", :to => 'projects#delete_message', :method => 'delete'
  get "/projects/:project_id/add_user/:add_user_id/change_privilege/edit", :to => 'projects#edit_privilege'
  put "/projects/:project_id/add_user/:add_user_id/change_privilege", :to => 'projects#update_privilege', :method => 'put'
  delete "/projects/remove_user/:add_user_id/destroy", :to => 'projects#destroy_user', :method => 'delete'
 
  
  
  root "users#index"
end

