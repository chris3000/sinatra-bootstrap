require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rack/test'
require 'rspec'
require 'sinatra'


# setup test environment
ENV['RACK_ENV'] = "test"
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

module AppHelper
  def app
    MyApp
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include AppHelper
end
