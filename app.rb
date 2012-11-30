# encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'yaml'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'omniauth-identity'

class MyApp < Sinatra::Application
  set :environment, :development
  set :domain, "127.0.0.1:9292"
  #set :domain, "my-awesome-website.com"
  set :company, "Some Company Name"
  set :site_name, "My Awesome Website"

 # set :environment, :production
  set :root, ::File.dirname(__FILE__)
  #change the session secret to something unique and secret
  set :session_secret, "go gators"
  enable :sessions

  use OmniAuth::Builder do
    cred = YAML.load_file("conf/keys.yml")
    provider :facebook, cred["facebook"]["id"],cred["facebook"]["secret"]
    provider :twitter, cred["twitter"]["consumer_key"], cred["twitter"]["consumer_secret"]
    provider :identity, :fields => [:username, :email], :model => User
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

    def current_user
      @current_user ||= User.where(:id => session[:user_id]).first if session[:user_id]
    end

    def authenticated?
      session.has_key?(:user_id)
    end
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
