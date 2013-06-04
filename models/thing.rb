require_relative 'modules/simple_scaffold.rb'
require_relative 'modules/slugur.rb'
class Thing
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include SimpleScaffold
  include Slugur
  field :thing_name,:type => String
  field :something, :type => String
  belongs_to :user

  validates_presence_of :thing_name,
                        :message => "Thing name is Required."
  validates_length_of :thing_name,
                      :minimum => 3,
                      :maximum => 300,
                      :message => "Names must be between 3 and 300 characters"
  validates_presence_of :something,
                        :message => "Something is Required."

  def thing_name= newname
    super(newname)
    slugify(newname, 50)
  end

  #------ scaffold   -------#
  #scaffold stuff
  SimpleScaffold.manage_ignore self, ["_id","_type", "created_at", "updated_at", "user_id"]
  SimpleScaffold.edit_ignore self, ["_id","_type", "created_at", "updated_at", "user_id"]
  SimpleScaffold.new_ignore self, ["_id","_type", "created_at", "updated_at", "user_id"]
  def human_id
    thing_name
  end
end
#------ scaffold end -----------#