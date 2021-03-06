

require 'rspec'
require 'webrat'
require 'rack/test'

ENV['RACK_ENV'] = "test"

require File.join(File.dirname(__FILE__), '..', 'app.rb')

# setup test environment
set :environment, :test
set :root, File.join(File.dirname(__FILE__), '..')
set :run, false
set :raise_errors, true
set :logging, false

module AppHelper
  def app
    MyApp
  end
end


Webrat.configure do |config|
  config.mode = :rack
end


RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers
  config.include AppHelper
end

