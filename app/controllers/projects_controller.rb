class ProjectsController < ApplicationController

    def new

    end

    def index
        @user = User.find_by_id(session[:id])
        @projects = @user.projects
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
        @project.topics.create(topic_params)
        # render plain: "page thread! for #{@project.topics.inspect}"
        redirect_to user_project_path(user_id: params[:user_id], id: params[:project_id])
    end 

    def show_topic
        @project = Project.find(params[:project_id])
        @user = User.find_by(session[:id].to_s)
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
        @topics = @project.topics
        render "topic_index"
    end

    def new_message
        @topic = Topic.find(params[:topic_id])
        @user = User.find(session[:id])
        @message = @topic.messages.create(message_params.merge({"user_id" => @user.id}))
        # render plain: "post creator #{message_params}, #{@topic.title}, #{@user.id}"
        # render plain: "#{@message.inspect}"
        redirect_to "/projects/#{params[:project_id]}/topic/#{params[:topic_id]}"
    end

    def edit_message
        @user = User.find(session[:id])
        @message = Message.find(params[:message_id])
        render  "message_edit"
    end

    def update_message
        render plain: "updater"
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

        

end
