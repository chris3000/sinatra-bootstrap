require_relative "../spec_helper"

describe Authentication do
  before :all do
    puts "DROPPING MONGO DB"
    Mongoid.purge!
  end
  before :each do
  @good_user = {
      :username => "chris2",
      :password => "something",
      :email => "chris2@goodexample.com",
      :password_confirmation => "something",
      :accept_terms => true
  }
  @good_auth_fb = {
      :uid => "12345",
      :provider => "facebook",
      :nickname => "test1_fb"
  }
  @good_auth_twitter = {
      :uid => "98765",
      :provider => "twitter",
      :nickname => "test1_tw"
  }
  end
  it "should create a good authentication" do
    user1 = User.create(@good_user)
    auth1a = Authentication.new @good_auth_fb
    user1.authentications << auth1a
    user1.verified = true
    user1.save
    auth1b = Authentication.new @good_auth_twitter
    user1.authentications << auth1b
    user1.save
  end

  it "should associate authentication to user" do
    user1 = User.find_by_username(@good_user[:username])
    puts user1.authentications.inspect
    user1.authentications[0].should_not == nil
    auth1 = Authentication.find(user1.authentications[0].id)
    auth1.user_id.should == user1.id
  end
end