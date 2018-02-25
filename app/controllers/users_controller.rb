class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update]
  def index
    @users = User.paginate(:page => params[:page], per_page: 5)
  end

  def show
    @user_articles = @user.articles.paginate(:page => params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the blog app #{@user.username}!"
      redirect_to user_path(@user)
    else
      render 'new'
      # or # render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "We've updated your details successfully!"
      redirect_to articles_path
    else
      render 'edit'
      # or # render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user
      flash[:danger] = "You can only edit your own profile"
    end
    redirect_to root_path
  end
end
