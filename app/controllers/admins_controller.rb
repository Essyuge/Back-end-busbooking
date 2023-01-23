class AdminsController < ApplicationController
    # before_action :authorize,

    def index
        admins = Admin.all
        render json: admins, status: :ok
    end

     def update
        admins = Admin.find_by(params[:id])
        admins.update!(admin_params)
        render json: admins
     end

    def show
        admins = Admin.find_by(session[:admins_id])
        if admins
            render json: admins
        else
            render json: {error: "user not authorized"}, status: :unauthorized
        end
    end

    def create
        admins = Admin.create!(admin_params)
        render json: admins, status: :created
    end

    def signup
        admins = Admin.create(admins_params)
        if admins.valid?
            session[:admins_id] = admins.id
            render json: admins, status: :created
        else
            render json: {errors: admins.errors.full_messages}, status: :unprocessable_entity
        end
    end

    def login
        admins = Admin.find_by(username: params[:username])
        if admins&.authenticate(params[:password])
            session[:admins_id] = admins.id
            render json: admins, status: :created
        else
            render json: {error: "Invalid username or password"}, status: :unauthorized
        end
    end

    def logout
        session.delete :user_id
        head :no_content
    end


    private

    def authorize
        render json: {error: "user not authorized"}, status: :unauthorized unless session.include? :user_id
    end

    def admin_params
        params.permit(:username, :email, :phone_number, :password, :password_confirmation)
    end
end
