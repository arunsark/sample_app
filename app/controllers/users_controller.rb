class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end 
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
end
