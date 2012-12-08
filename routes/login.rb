# encoding: utf-8
class MyApp < Sinatra::Application


  get "/login" do
    @title  = "Login"
    haml :login, :locals => {:user => current_user}
  end

  get '/signup' do
    identity = session[:identity]
    unless identity.valid?
      identity.errors.each {|k, v| puts "#{k.capitalize}: #{v}"}
    end
    session[:identity] = nil
    errors = session[:errors]
    session[:errors] = nil
    haml :signup, :locals => {:identity => identity, :errors => errors}
  end

  post '/signup' do
    user = User.create
  end

  get '/logout' do
    session[:user_id] = session[:pass] = nil
    redirect '/'
  end

  get '/auth/identity/callback' do
    puts "#{request.env['omniauth.auth']}"
    redirect '/login'
  end

  post '/auth/identity/callback' do
    puts "login successful- #{request.env['omniauth.auth']}"
    session[:user_id] = request.env['omniauth.auth']["uid"]
    redirect '/'
  end

  post '/auth/identity/register' do
    puts "im posting to register"
    "#{params}"
  end

  get '/auth/identity/register' do
    session[:user_id] = request.env['omniauth.auth']["uid"]
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
  end

  get '/auth/:provider/callback' do
    auth_req = request.env['omniauth.auth']
    redirect '/' unless auth_req
    # try to get authentication
      auth = Authentication.where(:provider => auth_req['provider'],
                                    :uid =>  auth_req['uid'].to_s).first
    #Did I find authentication?
    if auth
      #yes- get user and log in session
      user = auth.user
      session[:user_id] = user.id
    else
      #no, this is a new authentication
      new_auth = Authentication.create!(
          uid: auth_req['uid'],
          provider: auth_req['provider'],
          nickname: auth_req['info']['nickname'])
      #- is user already logged in through some other means?
      if (current_user)
        #create new authentication and add it to user
        current_user.authentications << new_auth
        current_user.save
      else
        session[:auth_provider] = auth_req['provider']
        session[:auth_uid] = auth_req['uid']
        #user is not logged in- send auth_req to "link" page
        redirect "/auth/#{new_auth.provider}/link"
      end
    end
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(auth_req)}</pre>
          <pre>#{JSON.pretty_generate(current_user)}</pre>"
  end

  get "/auth/:provider/link" do
    begin
      auth = Authentication.find_by(:provider => session[:auth_provider],
                                    :uid =>  session[:auth_uid])
    rescue Exception => e
      #this is pretty bad.  Add better logging later
      puts e.inspect
      redirect '/login'
    end
    haml :link_info, :locals => {:auth => auth}
  end

  get '/auth/failure' do
    if params["strategy"] == "identity"
      flash[:error] =params["message"]
      redirect '/login'
    end
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre><pre>#{request.env['omniauth.auth'].to_json}</pre>"
  end

  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end

  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless authenticated?
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
         <a href='/logout'>Logout</a>"
  end

end
