require_relative 'simple_scaffold.rb'
class Thing
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include SimpleScaffold

  field :thing_name, :type => String
  field :something, :type => String

  belongs_to :user

  validates_presence_of :thing_name,
                        :message => "Thing name is Required."
  validates_length_of :thing_name,
                      :minimum => 3,
                      :maximum => 30,
                      :message => "Names must be between 3 and 30 characters"
  validates_format_of :thing_name,
                      :with => /^[-\w\._]+$/i,
                      :message => "should only contain letters, numbers, '.', '-', or '_'"
  validates_presence_of :something,
                        :message => "Something is Required."

  #------ scaffold   -------#
  #scaffold stuff
  SimpleScaffold.manage_ignore self, ["_id","_type", "created_at", "updated_at"]

  def human_id
    thing_name
  end
end
#------ scaffold end -----------#