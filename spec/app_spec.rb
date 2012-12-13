require "spec_helper"
require '../app'
describe "main page" do

  it "should load home page" do
    visit "/"
#    assert true
   assert_contain 'World'
    #last_response.should be_ok
  end

end

