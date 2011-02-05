require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
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

end

