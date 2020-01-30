class UsersController < ApplicationController
    before_action :authorize_login, :only => [:login, :new]
    before_action :admin_check, :only => [:allusers,:make_admin]
    before_action :authorize_logout, :only => [:dashboard, :profile, :projects, :create_project, :show, :logout, :make_admin, ]


    def index
    end

    def new

    end

    def create
        @user = User.new(user_params)
        # render plain: @user.inspect
        @user[:userid] = SecureRandom.uuid

        if @user.save
            redirect_to login_users_path, :flash => { :success => "You have successfully signed up, please log_in"}
        
        else
            render 'new'
        
        end

    end

    def login 
    end

    def login_user
        
        @user = User.find_by_email(user_params[:email])
        if @user and @user.authenticate(user_params[:password])
            session[:email] = @user[:email]
            session[:userid] = @user[:userid]
            session[:id] = @user[:id]
            session[:fullname] = @user[:fullname]
            flash[:success] = "Welcome #{session[:fullname]}"
            redirect_to dashboard_users_path

        else

            if user_params[:email] == "" and user_params[:password] == ""
                flash[:error] = "please provide email and password"
            elsif user_params[:email] == ""
                flash[:error] = "empty email field!!!!"
            elsif user_params[:password] == ""
                flash[:error] = "please provide password"
            elsif @user == nil
                flash[:error] = "incorrect email provided"
            elsif @user != nil and @user[:email] != ""
                flash[:error] = "wrong password!"
            else
                flash[:error] = "please provide valid email and password" 

            end
            render "login"
        end
    end

    def dashboard
        @projects = Project.where(user_id: session[:id])
        @shared_projects = SharedProject.where(user_id: session[:id])
        @tasks = Task.where(user_id: session[:id])
        # @threads = Topic.where(user_id: session[:id])
    end

    def logout
        session[:email] = session[:userid] = session[:id] = session[:fullname] = nil
        flash[:info] = "you have been logged out!"
        redirect_to login_users_path
    end

    def destroy
        @user.destroy
        session[:logged_in] = session[:id] = session[:userid] = session[:email] = nil
        flash[:error] = "Account Deleted Successfully"
        redirect_to login_users_path
    end

    def profile
        @user = User.find_by_userid(session[:userid])
        # render plain: @user.inspect
    end

    def delete
        @user = User.find_by(userid: params[:user_id])
        @user.destroy
        flash[:info] = "Account Deleted Successfully"
        redirect_to allusers_users_path
    end

    def allusers
        @users = User.all
    end

    def make_admin
        @user = User.find(params[:id])
        if @user[:role] == false 
            @user.update_attribute(:role, true)
        else
            @user.update_attribute(:role, false)
        end
        redirect_to allusers_users_path
    end

    # def show
        
    # end

    private
        def user_params
            params.require(:user).permit(:fullname, :email, :password)
        end

        def admin_check

            if session[:id]
                @user = User.find(session[:id])
                if @user.role == false
                    flash[:alert] = "unauthorized access to /allusers!"
                    redirect_to  dashboard_users_path
                end
            else
                flash[:alert] = "unauthorized access to /allusers!"
                redirect_to login_users_path
            end

        end

    
    
end
