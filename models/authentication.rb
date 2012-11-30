
class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at

  field :provider, :type => String
  field :uid, :type => String
  field :nickname

  belongs_to :user

end