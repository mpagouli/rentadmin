class UsersController < ApplicationController
  
  #before_filter :signed_in_user
  #before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  #before_filter :correct_user,   only: [:edit, :update]
  #before_filter :admin_user,     only: [:index, :edit, :update, :destroy, :new, :create, :show]

  def index
  end
  def edit
  end
  def update
  end
  def destroy
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Account created successfully!"
      redirect_to @user
    else
      render 'new'
    end
  end


  private
    #def correct_user
    #  @user = User.find(params[:id])
    #  redirect_to(root_path) unless current_user?(@user)
    #end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
