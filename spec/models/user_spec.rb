require 'spec_helper'

# upon new() of a User, do the following validations
describe User do

  # do this before execution of this parent do block
  #   if no values are passed for name or email, then it will throw an
  #   exception 
  before do    
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # indicates that @user will be the subject of the following validations
  subject { @user }

  # validates that user has a value for name and email hashes
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  
  # token used for tracking sessions (cookie)
  it { should respond_to(:remember_token) }
  
  
  # implies the authenticate method should return non-false
  it { should respond_to(:authenticate) }
  
  # .be_valid corresponds  to user.valid.  That boolean is
  #     set in the model file that defines the User class = user.rb
  #  the remaining tests are mostly nested verifications of the user.rb validations
  it { should be_valid }

  # this is a nested test that verifies the model's test was not 
  #   a false positive - see user.rb
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
    
  #  again, the model should not have given us this value
  #    if the name was too long - see user.rb
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  # this is a nested test that verifies the model's test was not 
  #   a false positive
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
    
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end  
  
  describe "when email address is already taken" do
    before do
      # duplicate the entered address, convert case,  and save it
      #  we should have no duplicates even if case different.  this
      #  seems useless sense we downcase all emails before saving them
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end  
  
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
      before { @user.password_confirmation = "mismatch" }
      it { should_not be_valid }  
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    # save it to DB so the following find_by method will work 
    before { @user.save }
    
    # do a lookup and set local variable to result
    let(:found_user) { User.find_by(email: @user.email) }

    # since found_user and @user are referencing the same person
    #   this should match
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    # pass incorrect password and make sure it fails
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      # not equal ...
      it { should_not eq user_for_invalid_password }

      #  and false return code
      specify { expect(user_for_invalid_password).to be_false }
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end  

end  
  
