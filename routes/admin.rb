# encoding: utf-8
class MyApp < Sinatra::Application
  ['/admin', '/admin/*'].each do |path|
    before path do
      @model_list = ["User","Authentication"]
      session['db_list']=20
    end
  end

  get "/admin/?" do
    @title = settings.environment
      haml :'admin/admin_main', :layout => :'admin/admin_layout'
  end

  def get_model_class class_name
    Kernel.const_get(class_name.capitalize)
  end

  get "/admin/:model/show/:id/?" do
    model_class = get_model_class params['model']
    model_instance = model_class.find(params[:id])
    model = model_instance.scaffold_show
    puts "show model - #{model.inspect}"
    haml :'admin/admin_show', :layout => :'admin/admin_layout', :locals =>{:model => model}
  end

  get "/admin/:model/manage/?" do
    model_class = get_model_class params['model']
    if model_class.singleton_methods.include? :scaffold_manage_headings
      model_field_headings = model_class.scaffold_manage_headings
      puts "I found scaffold manage headings"
    else
      puts "defaulting to all fields"
      model_fields = model_class.fields.keys
    end
#    test_user = User.find_by_username "chris3000"
#    auth = "username"
#    puts (test_user.send auth.to_sym).inspect
    model_instances = []
    models = model_class.limit(20).skip(0)
    models.each do |model|
       model_instances << model.scaffold_manage
    end
    haml :'admin/admin_manage', :layout => :'admin/admin_layout', :locals =>{:model_instances => model_instances,
                                                                             :model_field_headings => model_field_headings}
  end

  post "/admin/:model/delete/?" do
    xhr_response = {:action => "delete"}
    begin
      model_classname = params['model'].capitalize
      model_class = Kernel.const_get(model_classname)
      model = model_class.find(params['id'])
      model.delete
      msg = "Delete of #{params['id']} successful."
      status = "success"
    rescue Exception => e
      msg = "Delete for ID '#{params['id']}' Failed"
      status = "fail"
      puts e.message
      puts e.backtrace.inspect
    end
    if request.xhr?
      xhr_response[:status] = status
      xhr_response[:message] = msg
      json xhr_response
    else
      if status == "success"
        flash[:notice] = msg
      else
       flash[:error] = msg
      end
      redirect("/admin/#{params['model']}/manage/")
    end
  end

end
