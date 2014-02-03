class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  # for user.valid to be true, following must be executed and pass
  #  name is provided and less than 50 chars
  validates :name,  presence: true, length: { maximum: 50 }
  
  #  email address does not contain capitals, contains an @ and other stuff
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  # 
  # has_secure_password does several things:
  # checks 
  #    1. password exists, 
  #    2. password matches, 
  # provides:
  #   an authen method that compares encrypted password to the stored digest
  has_secure_password
  
  validates :password, length: { minimum: 6}
end
