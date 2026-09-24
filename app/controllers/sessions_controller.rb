class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [ :new ]

  def new
  end

  def create
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      ActivityLog.create!(
        user: user,
        action: "login",
        subject_type: "User",
        subject_id: user.id,
        details: "Successful login"
      )
      redirect_to pages_path
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
