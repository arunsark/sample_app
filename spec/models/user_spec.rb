require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end

  it "should create a new instance given valid attributes" do
    user = User.create!(@attr)
    user.should be_valid
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name=>""))
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email=>""))
    no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[arun-@yahoo.com arun.v@gmail.com arun_v@foo.bar.com]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email=>address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[arunyahoo.com arun.v@gmail,com arun_v@foo.]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email=>address))
      valid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    email_in_upcase = @attr[:email].upcase
    User.create! (@attr)
    user_with_dup_email = User.new(@attr.merge(:email=>email_in_upcase))
    user_with_dup_email.should_not be_valid
  end

  describe "Password Validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password=>"",:password_confirmation=>"")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation=>"fobar")).
        should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 5
       User.new(@attr.merge(:password=>short,:password_confirmation=>short)).
        should_not be_valid
    end

    it "should reject long password" do
      short = "a" * 41
       User.new(@attr.merge(:password=>short,:password_confirmation=>short)).
        should_not be_valid
    end

  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

   it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 

  describe "authentication method" do
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email],"junk")    
      wrong_password_user.should be_nil
    end

    it "should return nil for email with no user" do
      wrong_password_user = User.authenticate("foo@bar.com",@attr[:password])    
      wrong_password_user.should be_nil
    end

    it "should return user for email/password match" do
      valid_user = User.authenticate(@attr[:email],@attr[:password])    
      valid_user.should_not be_nil
      valid_user.should == @user
    end
  
  end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end

  end
  
end
