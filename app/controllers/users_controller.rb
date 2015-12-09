class UsersController < ApplicationController
  def new
    @user = User.new(email: params["email"], password: params["password"])
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      render "new.json.jbuilder", status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render "create.json.jbuilder", status: :accepted
    else
      render json: { errors: "email or password incorrect" }, status: :unauthorized
    end
  end
end