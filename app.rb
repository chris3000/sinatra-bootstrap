# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'yaml'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-twitter'

class MyApp < Sinatra::Application
  set :environment, :development
  set :domain, "127.0.0.1:9292"
  #set :domain, "my-awesome-website.com"
  set :company, "Some Company Name"
  set :site_name, "My Awesome Website"

 # set :environment, :production
  set :root, ::File.dirname(__FILE__)

  enable :sessions
  use OmniAuth::Builder do
    cred = YAML.load_file("conf/keys.yml")
    puts cred.inspect
    provider :facebook, cred["facebook"]["id"],cred["facebook"]["secret"]
    provider :twitter, cred["twitter"]["consumer_key"], cred["twitter"]["consumer_secret"]
  end

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
