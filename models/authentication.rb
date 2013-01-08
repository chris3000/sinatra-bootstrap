require_relative 'simple_scaffold.rb'
class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include SimpleScaffold

  field :provider, :type => String
  field :uid, :type => String
  field :nickname, :type => String

  belongs_to :user

  #------ scaffold   -------#
  #scaffold stuff
  SimpleScaffold.manage_ignore self, ["_id","_type", "created_at", "updated_at", "user_id"]

  def human_id
    to_s
  end


  def to_s
    "#{provider}[ #{nickname} ]"
  end
end
#------ scaffold end -----------#