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

  get "/admin/:model/manage/?" do
    model_classname = params['model'].capitalize
    model_class = Kernel.const_get(model_classname)
    if model_class.singleton_methods.include? :scaffold_manage
      model_fields = model_class.scaffold_manage
      puts "I found scaffold manage"
    else
      puts "defaulting to all fields"
      model_fields = model_class.fields.keys
    end
    test_user = User.find_by_username "chris3000"
    auth = "username"
    puts (test_user.send auth.to_sym).inspect
    model_instances = model_class.limit(20).skip(0)
    haml :'admin/admin_manage', :layout => :'admin/admin_layout', :locals =>{:model_instances => model_instances,
                                                                             :model_fields => model_fields}
  end
end
