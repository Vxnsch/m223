module Admin
  class UsersController < ApplicationController
    before_action :require_login

    def index
      authorize User
      @users = policy_scope(User).order(:email)
    end

    def update
      @user = User.find(params[:id])
      authorize @user

      @user.role = params.require(:user).fetch(:role)

      if @user.save
        redirect_to admin_users_path, notice: "User role updated."
      else
        redirect_to admin_users_path, alert: @user.errors.full_messages.to_sentence
      end
    end
  end
end
