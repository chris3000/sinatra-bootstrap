# encoding: utf-8
class MyApp < Sinatra::Application


  get "/login" do
    @title  = "Login"
    haml :login
  end

  #only necessary if you do your own authentication
  post "/login" do
    # Define your own check_login
    if user = check_login
      session[ :user ] = user.pk
      redirect '/'
    else
      redirect '/login'
    end
  end

  get "/logout" do
    session[:user] = session[:pass] = nil
    session[:authenticated] = false
    redirect '/'
  end

  get '/auth/:provider/callback' do
    session[:authenticated] = true
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
  end

  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end

  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end

  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless session[:authenticated]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end

end
