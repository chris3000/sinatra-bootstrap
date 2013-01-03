require_relative "../spec_helper"

def getRandomString
  (0...8).map{65.+(rand(26)).chr}.join
end

def getRandomEmail
  "#{getRandomString}@#{getRandomString}.com"
end

describe "Login and Signup pages" do
  #kill the mongo test dbs

  before :all do
    puts "DROPPING MONGO DB"
    Mongoid.purge!
  end
  it 'should load signup page' do
    visit "/signup"
    #last_response.should be_ok
  end

  it 'should load login page' do
    visit "/login"
   # last_response.should be_ok
  end

  it 'should create new user' do
    @good_login = {
        :username => "chris",
        :password => "something",
        :email => "chris@mailtochris.com",
        :password_confirmation => "something",
        :accept_terms => true
    }
     post "/signup", @good_login
     puts @good_login
     follow_redirect!
    last_response.body.match("verify_twitter").should be_true
     last_response.body.match("error_messages").should be_false
     last_response.should be_ok
  end

  it 'should go from navbar to new user' do
    visit "/"
    click_link "Sign up for free"
    fill_in "username", :with => "goodtest"
    fill_in "email", :with => "good@example.com"
    fill_in "password", :with => "secret_password"
    fill_in "password_confirmation", :with => "secret_password"
    check "accept_terms"
    click_button "Create an account"
    follow_redirect!
    last_response.should contain("Welcome")
  end


  @bad_signup = {
      :username => "a", #not long enough
      :password => "b", #not long_enough
      :password_confirmation => "c", #not the same as password
      :email => "abc"
  }
  it "should have errors if new user is invalid" do
    post "/signup", @bad_signup
    last_response.body.match("error_messages")
    last_response.should be_ok
  end
end