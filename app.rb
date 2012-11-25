# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'haml'

class MyApp < Sinatra::Application
  set :environment, :development
  set :company, "Some Company Name"
  set :site_name, "My Awesome Website"
 # set :environment, :production
  set :root, ::File.dirname(__FILE__)

  enable :sessions

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
      register Sinatra::Reloader
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
