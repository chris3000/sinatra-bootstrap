# encoding: utf-8
class MyApp < Sinatra::Application
  get "/" do
    @title = settings.environment
      haml :main
  end
end
