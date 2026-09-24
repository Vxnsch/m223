class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    @user.errors.add(:email, :taken)
    render :new, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
