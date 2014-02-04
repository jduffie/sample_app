module SessionsHelper

  # invoked to setup cookies and get a reference to user
  def sign_in(user)
    # create un-encrypted token
    remember_token = User.new_remember_token
    
    # place token in cookies
    cookies.permanent[:remember_token] = remember_token
    
    # write encrypted token to DB for "user"
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    
    # assign current user to "user" - see following method for implementation
    self.current_user = user
  end
  
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end  
  
  # invoked by sign_in to assign user to current_user
  def current_user=(user)
    @current_user = user
  end  
 
  # invoked to get current user 
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    
    # only do the find_by  if current_user is undefined
    @current_user ||= User.find_by(remember_token: remember_token)
  end
  
  def signed_in?
    !current_user.nil?
  end  
      
end
