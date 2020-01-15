class ProjectsController < ApplicationController

    def new

    end

    def index
        render plain: "why am i here?"
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
        @projects = Project.all
    end

    def destroy
        @project = Project.find(params[:id])
        flash[:info] = "project #{@project.title} deleted!"
        @project.destroy
        redirect_to user_project_path
    end

    private
        def project_params
            params.require(:project).permit(:title, :body)
        end

end
