class UsersController < ApplicationController
  include  ActiveModel::MassAssignmentSecurity
  helper_method :requested_user, :user
  attr_accessible :login, :avatar, :password, :password_confirmation, :email, :as => :user
  attr_accessible :login, :avatar, :as => :user_update

  def new
    require_no_user
  end

  def index
    redirect_to session_path
  end
  
  def create
    require_no_user
    @user = User.new(params[:user], :as => :user)
    if @user.save
      flash[:notice] = "Account registered!"
      UserSession.new(@user).save
    else
      render :action => :new
    end
  end

  def verify
    user = User.find_by(verification_token: params[:token])
    user.verify_email
    UserSession.new(user).save
  end
  
  def show
    require_user
  end

  def edit
    require_user
    authorize! :update, requested_user
  end
  
  def update
    require_user
    authorize! :update, requested_user
    if requested_user.update_attributes(params[:user], :as => :user_update)
      flash[:notice] = "Account updated!"
      redirect_to user_url
    else
      render :action => :edit
    end
  end

private

  def requested_user
    requested_user_by_id(params[:id])
  end

  def user
    return @user if defined?(@user)
    @user = User.new
  end
end