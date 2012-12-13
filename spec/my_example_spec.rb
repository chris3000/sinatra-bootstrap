require 'spec_helper'
describe MyApp do
  it "should respond to /" do
    visit "/"
    assert be_true
  end
end

describe "My behaviour" do

  it "should do something" do

    #To change this template use File | Settings | File Templates.
    true.should == false
  end
end