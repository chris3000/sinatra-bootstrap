require 'mongoid'
#configure Mongoid
Mongoid.load!(::File.expand_path("../conf/mongoid.yml", File.dirname(__FILE__)), "development")

class Counter
  include Mongoid::Document

  field :seq,:type => Integer, default: 0

end

counter = Counter.new
counter.id="test"
counter.save

10.times do
  val = counter.inc(:seq, 1)
  puts "counter for test = #{val}"
end