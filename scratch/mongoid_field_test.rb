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
puts Authentication.scaffold_list_items.inspect
puts Authentication.scaffold_association_classes.inspect
puts User.scaffold_association_classes.inspect
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