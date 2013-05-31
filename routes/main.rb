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

  post "/account" do
    user = current_user
    this_user_page =  (params[:pk].to_s == user.id.to_s)
    if !this_user_page
      puts "not allowed- #{params[:pk]}, #{user.id}, #{this_user_page}"
      403
    else
      if params[:cls] && params[:name] && params[:value] && params[:pk]
        obj = Kernel.const_get(params[:cls]).find(params[:pk])
        if obj
          ret={}
          ret_obj = obj.send("#{params[:name]}=",params[:value])
          obj.save
          #puts "set #{obj.class.to_s}.#{params[:name]} to #{obj.send(params[:name])}"
          ret[:success] = true
          ret[:return_info] = ret_obj
          json ret
        end
      else
        500
      end
    end
  end

  get "/:user_page/?" do
    user = current_user
    this_user_page =  (params[:user_page] == user.username)
    haml :user_page, :locals => {:user => user, :this_user_page => this_user_page}
  end
end
