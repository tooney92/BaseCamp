class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?, :admin_role, :is_admin?

    def admin_role
        @client ||=User.find_by_email(session[:email])
        return @client.role
    end

    def is_admin?
        if admin_role == nil or !admin_role
            return false
        else
            return true
        end
    end

    def current_user
        @current_user ||=User.find_by_email(session[:email])
    end

    def logged_in?
        current_user != nil
    end

    def authorize_login
        if logged_in?
            redirect_to dashboard_users_path
        end
    end

    def authorize_logout
        if !logged_in?
            redirect_to login_users_path
        else
            @user = User.find_by(userid: session[:userid])
        end
    end

    def check_authority
        @project = Project.find(params[:id])
        @shared_project = SharedProject.where("user_id = :user_id and project_id = :project_id", {project_id: params[:id], user_id: session[:id]} )

        if session[:id] == @project.user_id
        
        elsif session[:id] != @project.user_id and @shared_project[0] == nil
            flash[:alert] = "you do not have the permission to do this!!"
            redirect_to dashboard_users_path

        elsif session[:id] != @project.user_id and @shared_project[0].read == true
            # flash[:alert] = "you do not have the permission to do this!!"
            # redirect_to dashboard_users_path 
        else
            flash[:alert] = "you do not have the permission to do this!!"
            redirect_to dashboard_users_path
        end
    end
end
