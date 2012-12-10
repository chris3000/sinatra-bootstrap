require_relative "../spec_helper"

describe "main page" do

  it "should load home page" do
    get '/'
    last_response.should be_ok
  end

end

