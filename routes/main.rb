# encoding: utf-8
class MyApp < Sinatra::Application
  get "/" do
    @title = settings.environment
      haml :main
  end

  get "/account" do
    user = current_user
    redirect '/signup' unless user
    haml :account, :locals =>{:user => user}
  end
end
