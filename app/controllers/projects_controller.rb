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

        # render plain: @project.inspect
        


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
    end

    def destroy
        @project = Project.find(params[:id])
        flash[:info] = "project #{@project.title} deleted!"
        @project.destroy
        redirect_to user_project_path
    end

    def edit
        @project = Project.find_by(params[:id])
    end 

    def update
        @project = Project.find_by(session[:id])
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
            @project.save
            redirect_to user_project_path

        end
    end

    def read
        @project = Project.find_by_user_id(params[:id])
        render plain: @project.inspect
    end

    private
        def project_params
            params.require(:project).permit(:title, :body)
        end

end
