require 'mongoid'
#configure Mongoid
Mongoid.load!(::File.expand_path("../conf/mongoid.yml", File.dirname(__FILE__)), "development")
require_relative('../models/thing')


def create
name="TIL a high school student was sucked out of an airplane after it was struck by lightning. She fell 3.2 kilometers to the ground still strapped to her chair and lived. Only to endure a 9 day walk to the nearest civilzation."
something="something thing1"
thing1 = Thing.create(:thing_name => name, :something=>something)

t1test = Thing.find thing1.id

puts t1test.url_slug
puts t1test.slug_id
#t1test.delete
  t1test.id
end

def update(id)
  t1test = Thing.find id
  t1test.thing_name= "this is a new name"
  t1test.save
  puts t1test.url_slug
  puts t1test.slug_id
  t1test.slug_id
end

def delete(id)
  t1test = Thing.find id
  t1test.delete
end



id = create
url_id = update id
#delete id
t = Thing.slugur_find(url_id)
puts t.url_slug