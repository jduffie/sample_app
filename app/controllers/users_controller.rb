class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  
  def create
    
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      
      # invoke sign_in method on this user so everything gets cached
      
      sign_in @user
      
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
 private
   
    # following is for security. it prevents user from POSTing and overloading all members of the user class
    def user_params
      # the "params[] var is embedded in the HTML - we don't see it in the project b/c the source is auto-gened by the form_for "
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
