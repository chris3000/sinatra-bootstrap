require_relative "../spec_helper"

describe User do
  before :all do
    puts "DROPPING MONGO DB"
    Mongoid.purge!
  end

  it "should create and save a User" do
    @good_user = {
        :username => "chris",
        :password => "something",
        :email => "chris@goodexample.com",
        :password_confirmation => "something",
        :accept_terms => true
    }
    user = User.create(@good_user)
    user.errors.any?.should == false
  end

  it "should fail to create a bad User" do
    @bad_user = {
        :username => "chris",
        :password => "s",
        :email => "fail",
        :password_confirmation => "s",
        :accept_terms => true
    }
    user = User.create(@bad_user)
    user.errors.any?.should == true
  end

  it "should create manage scaffold for user" do
    test1 = User.find_by_username("chris")
    test1_man_scaff = test1.scaffold_manage
    puts test1_man_scaff.inspect
    test1_man_scaff[:heading_titles].should == false
    test1_man_scaff[:human_id].should == test1.human_id
    test1_man_scaff[:id].should == test1.id
    test1_man_scaff[:model_name].should == test1.class.name.to_s
    test1_man_scaff[:fields]["username"].should == test1.username
    test1_man_scaff[:fields]["email"].should == test1.email
    test1_man_scaff[:fields]["_type"].should == nil

  end

  it "should create User-manage headings" do
    user_headings = User.scaffold_manage_headings
    puts user_headings
    user_headings[:heading_titles].should == true
    user_headings[:human_id].should == "HEADINGS"
    user_headings[:id].should == "HEADINGS"
    user_headings[:model_name].should == User.name.to_s
    user_headings[:fields]["sign_in_count"].should == Integer
    user_headings[:fields]["username"].should == String
    user_headings[:fields]["email"].should == String
    user_headings[:fields]["verified"].should == Boolean
    user_headings[:associations][:has_many][0].should == :authentications
    user_headings[:fields]["_type"].should == nil
  end

end