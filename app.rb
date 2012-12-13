# encoding: utf-8
require 'sinatra'
require 'rack-flash'
require 'sinatra/reloader'
require 'haml'
require 'yaml'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-twitter'
#require 'omniauth-identity'

class MyApp < Sinatra::Application
  set :environment, (ENV['RACK_ENV'] || :development)
  set :domain, "127.0.0.1:9292"
  #set :domain, "my-awesome-website.com"
  set :company, "Some Company Name"
  set :site_name, "My Awesome Website"

  set :root, (settings.root || File.dirname(__FILE__))
  #change the session secret to something unique and secret
  set :session_secret, "go gators"
  enable :sessions
  #use Rack::Session::Cookie
  use Rack::Flash

  use OmniAuth::Builder do
    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
    cred = YAML.load_file(File.expand_path("conf/keys.yml", settings.root))
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
     #stolen from rails source code
    def pluralize(count, singular, plural = nil)
      word = if (count == 1 || count =~ /^1(\.0+)?$/)
               singular
             else
               plural || singular.pluralize
             end

      "#{count || 0} #{word}"
    end

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
