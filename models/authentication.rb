
class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  field :provider, :type => String
  field :uid, :type => String
  field :nickname

  belongs_to :user

  #------ scaffold   -------#
  def self.scaffold_manage
    all_field_names = self.fields.keys
    remove_list = ["_id","_type",
                   "created_at",
                   "updated_at",
                   ]
    remove_list.each do |remove_field|
      all_field_names.delete remove_field
    end
    all_field_names << "user"
    all_field_names
  end

  #something that ID's the model to a human
  def human_id
    to_s
  end

  def to_s
    "#{provider}[ #{nickname} ]"
  end
end
#------ scaffold end -----------#