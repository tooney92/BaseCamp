class ProjectsController < ApplicationController
    before_action :authorize_logout, :only => [:mytasks_project, :addtasks_project, :update_privilege, :edit_privilege, :myusers_project, :shared_projects, :add_user, :file_index, :delete_image, :delete_message, :edit_message, :new_message, :index_topic, :delete_topic, :update_topic, :edit_topic, :show_topic, :new_topic, :read, :update, :edit, :new, :index, :shared_projects, :create, :projects, :create_project, :show, :destroy, ]
    before_action :check_authority, :only => [:show]

    def new

    end

    def index
        @user = User.find_by_id(session[:id])
        @projects = @user.projects.order("created_at DESC")
    end

    def create
        @project = Project.new

        @project[:title] = project_params['title']
        @project[:body] = project_params['body']
        @project[:project_id] = SecureRandom.uuid
        @project[:user_id] = session[:id]
        @project.attachments.attach(params[:project][:attachments])

        if @project.save
            
            redirect_to dashboard_users_path, :flash => { :success => "new project added!"}

        else

            if project_params[:title] == "" and project_params[:body] == ""
                flash[:error] = "empty title and body! please fill both!"
            elsif project_params[:body] == ""
                flash[:error] = "empty body!!!!"
            elsif project_params[:title] == ""
                flash[:error] = "please provide title"
            end

            render 'new'

        end
     end

    def show
        # render plain: "i am projects view"
        # render 'show'
        # @shared_project = SharedProject.new
        @project = Project.find_by_id(params[:id])
        @topics = @project.topics

        # render plain: @topics.inspect
        # @comments = @topics.map do |topic|
        #     topic.comments
        # end
    end

    def destroy
        @project = Project.find(params[:id])
        flash[:info] = "Project: #{@project.title}was deleted!"
        @project.destroy
        redirect_to user_projects_path
    end

    def edit
        @project = Project.find_by(id: params[:id])
    end 

    def update
        @project = Project.find(params[:id])
        @project.body = project_params['body']
        @project.title = project_params['title']
        
        if project_params['body'] == ""  and  project_params['title'] == ""
            flash[:error] = "cannot save empty title and body!!"
            render 'edit'
            
        elsif project_params['body'] == "" 
            flash[:error] = "cannot save empty body!!!!!"
            render 'edit'

        elsif project_params['title'] == "" 
            flash[:error] = "cannot save empty title!!!!"
            render 'edit'

        else
            flash[:success] = "project updated successfully!!"
            @project.update(project_params.except(:attachments))
            @project.attachments.attach(project_params[:attachments])
            redirect_to user_projects_path

        end
    end

    def read
        @project = Project.find_by_user_id(params[:id])
        render plain: @project.inspect
    end

    def new_topic
        @project = Project.find(params[:project_id])

        if topic_params[:title].empty? 
            flash[:error] = 'Sorry cannot create  blank thread'
            redirect_to "/projects/#{params[:project_id]}/topics/index"
        else
            flash[:success] = 'thread created sucessfully'
            @project.topics.create(topic_params)
            redirect_to "/projects/#{params[:project_id]}/topics/index"
        end
        # render plain: "page thread! for #{@project.topics.inspect}"
        
    end 

    def show_topic
        @project = Project.find(params[:project_id])
        @user = User.find(session[:id].to_s)
        @topic = Topic.find(params[:topic_id])
        # @messages = Message.find(@topic.id)
        render "thread_show"
    end

    
    def edit_topic
        @project = Project.find(params[:project_id])
        @topic = Topic.find(params[:topic_id])
        render 'thread_edit'
    end
    
    def update_topic
        @topic = Topic.find(params[:topic_id])
        @project = Project.find(params[:project_id])
        @topic.title = topic_params['title']
        @topic.save
        flash[:success] = "thread updated successfully!!"
        redirect_to "/projects/#{params[:project_id]}/topics/index"
    end
    
    def delete_topic
        @topic = Topic.find(params[:topic_id])
        @project = Project.find(params[:project_id])
        flash[:info] = "thread: #{@topic.title}, was deleted!"
        @topic.destroy
        redirect_to "/projects/#{params[:project_id]}/topics/index"
        # render "topic_index"
    end

    def index_topic
        @project = Project.find(params[:project_id])
        @topics = @project.topics.order("created_at DESC")
        # render plain: @project.inspect
        render "topic_index"
    end

    def new_message
        @topic = Topic.find(params[:topic_id])
        @user = User.find(session[:id])
        @message = Message.new(message_params)
        @message.user_id = session[:id]
        @message.topic_id = @topic.id

        if message_params[:message].empty?
            flash[:error] = "cannot add blank comment!"
            redirect_to "/projects/#{params[:project_id]}/topic/#{params[:topic_id]}"
        else
            flash[:success] = "comment added sucessfully!"
            @message.save
            redirect_to "/projects/#{params[:project_id]}/topic/#{params[:topic_id]}"
        end
        
        # render plain: @message.inspect
        # @message = @topic.messages.create(message_params.merge({"user_id" => @user.id}))
        # render plain: "post creator #{message_params}, #{@topic.title}, #{@user.id}"
        
    end

    def edit_message
        @user = User.find(session[:id])
        @message = Message.find(params[:message_id])
        render  "message_edit"
    end

    def update_message
        @message = Message.find(params[:message_id])
        @message.message = message_params[:message]
        @message.save
        flash[:success] = "comment updated successfully!!"
        redirect_to "/projects/#{params[:project_id]}/topic/#{params[:topic_id]}"
    end

    def delete_message
        @message = Message.find(params[:message_id])
        @message.destroy
        flash[:danger] = "Comment deleted successfully!!"
        redirect_to "/projects/#{params[:project_id]}/topic/#{params[:topic_id]}"
    end

    def delete_image
        @image = ActiveStorage::Attachment.find(params[:image_id])
        @image.purge
        redirect_to user_project_path(user_id: session[:id], id: params[:project_id])
    end

    def file_index
        render plain: "file view"
    end

    def add_user
        @user = User.find_by_email(share_project_params['user_id'])
        @shared_project = SharedProject.new(share_project_params) 
        @shared_project.user_id = @user.id
        
        if @shared_project.save 
            redirect_to "/users/#{session[:id]}/projects/#{params[:project_id]}"
        else
            render plain: "not saved, #{share_project_params.inspect}"
        end
    end

    def shared_projects
        @shared_projects = SharedProject.where(user_id: session[:id])
    end

    def myusers_project
        @shared_users = SharedProject.where(project_id: params[:project_id])
        render 'my_users'
    end

    def edit_privilege
        @user = SharedProject.find(params[:add_user_id])
        @username = @user.user.fullname
        render  'edit_privilege'
    end

    def update_privilege
        @added_user = SharedProject.find(params[:add_user_id])
        @added_user.read = share_project_params[:read]
        @added_user.write = share_project_params[:write]
        @added_user.modify = share_project_params[:modify]
        @added_user.trash = share_project_params[:trash]
        flash[:success] = "#{@added_user.user.fullname} privelges updated!"
        @added_user.save

        redirect_to "/users/#{session[:id]}/projects/#{@added_user.project_id}/add_users/index"
    end

    def destroy_user
        @added_user = SharedProject.find(params[:add_user_id])
        @added_user.destroy
        # render plain: "i am the deleter"
    end

    def mytasks_project
        render 'add_task'
    end

    def addtasks_project
        @user = User.find(session[:id])
        @task = Task.new(mytasks_project_params)
        @task.user_id = session[:id]
        @task.project_id = params[:project_id]
        
        if @task.save
            flash[:success] = "task added"
            redirect_to "/users/#{session[:id]}/projects"
        else    
            flash[:error] = "cannot add blank task!"
            redirect_to  "/users/#{session[:id]}/projects/#{params[:project_id]}/add_task"
        end
       
    end

    def alltasks_project
        @tasks = Task.where(project_id: params[:project_id])
        render 'index_task'
        # render plain: @tasks[0].user.fullname
    end

    def edit_task
        @task = Task.find(params[:task_id])
        render 'edit_task'
    end

    def update_task
        @task = Task.find(params[:task_id])
        @task.task = mytasks_project_params[:task]
        if @task.save
            flash[:success] = "task added"
            redirect_to "/users/#{session[:id]}/projects/#{params[:project_id]}/add_task/index"
        else    
            flash[:error] = "cannot add blank task!"
            redirect_to  request.fullpath
        end
    end

    def destroy_task
        @task = Task.find(params[:task_id])
        @task.destroy
        flash[:error] = "task deleted!"
        redirect_to "/users//#{session[:id]}/projects/#{params[:project_id]}/add_task/index"
        
    end

    private
        def project_params
            params.require(:project).permit(:title, :body, attachments: [])
        end

        def topic_params
            params.require(:topic).permit(:title)
        end

        def message_params
            params.require(:message).permit(:message)
        end

        def share_project_params
            params.require(:share_project).permit(:user_id, :read, :write, :modify, :trash, :project_id)
        end

        def mytasks_project_params
            params.require(:task).permit(:task)
        end
        

end
