require 'mongoid'
require_relative('../models/user')
require_relative('../models/authentication')
require_relative('../models/thing')
#configure Mongoid
Mongoid.load!(::File.expand_path("../conf/mongoid.yml", File.dirname(__FILE__)), "development")

test1 = User.find_by_username("test_user1")
#puts "human id= #{test1.human_id}"
test1_man_scaff = test1.scaffold_manage
puts test1_man_scaff.inspect
auth1 = Authentication.find(test1_man_scaff[:associations][:has_many][0][:authentications][:ids][0][:id])
puts auth1.scaffold_manage.inspect
puts User.scaffold_manage_headings.inspect
puts Authentication.scaffold_manage_headings.inspect
thing1 =Thing.find(test1_man_scaff[:associations][:has_many][1][:things][:ids][0][:id])
puts thing1.scaffold_manage.inspect
#User.setfoo
#puts test1.instance_foo.inspect
=begin
  all_associations = [:has_many, :has_one, :belongs_to, :embeds_many, :embeds_one, :embedded_in, :has_and_belongs_to_many]
  ass_obj_array = []
  all_associations.each do |ass|
    User.reflect_on_all_associations(ass).each {|rr| ass_obj_array << rr}
  end
  associations = {}
  ass_obj_array.each do |ass_object|
    macro = ass_object.macro
    name = ass_object.name
    class_name = ass_object.class_name
    ids = test1.send "#{class_name.downcase}_ids"
    value_obj = {name.to_sym => {:class_name => class_name, :ids => ids }}
    #puts ids.inspect
    if associations[ass_object.macro]
      associations[ass_object.macro].merge!(value_obj)
    else
      associations[ass_object.macro] = value_obj
    end
  end
  puts associations.inspect
=end
 User.fields.each do |field|
   #puts field[0]
   field_obj = field[1]
   #puts field_obj.name
   #puts field_obj.options[:type]
 end

#puts User.reflect_on_association :authentications
User.validators.each do |validator|
 # if validator.include?
end