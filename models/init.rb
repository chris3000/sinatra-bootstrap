# encoding: utf-8

require_relative 'user'
require_relative 'authentication'
require_relative 'thing'

configure :development do
  puts "configuring development in model init"
  user1 = User.find_or_create_by(username:"test_user1", password:"passwd1")
  #user1 = User.new
  #user1.username = "test_user1"
  #user1.password = "passwd1"
  user1.accept_terms = true
  user1.email = "test1@user1.com"
  user1.save

  user2 = User.new
  user2.username = "test_user2"
  user2.password = "passwd2"
  user2.accept_terms = true
  user2.email = "test2@user2.com"
  user2.save

  auth1a = Authentication.new
  auth1a.uid = "22222"
  auth1a.provider = "facebook"
  auth1a.nickname = "test1_fb"
  user1.authentications << auth1a
  user1.verified = true
  auth1b = Authentication.new
  auth1b.uid = "11111"
  auth1b.provider = "twitter"
  auth1b.nickname = "test1_tw"
  user1.authentications << auth1b
  user1.save

  auth2a = Authentication.new
  auth2a.uid = "99999"
  auth2a.provider = "facebook"
  auth2a.nickname = "test2_fb"
  user2.authentications << auth2a
  user2.verified = true
  user2.save
  puts "things count=#{user1.things.count}"
  if user1.things.count == 0
    thing1 = Thing.new
    thing1.thing_name = "my_thing1"
    thing1.something = "this is something..."
    user1.things << thing1
    user1.save
  end
end