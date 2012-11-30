# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include OmniAuth::Identity::Models::Mongoid

  field :first_name, :type => String
  field :last_name, :type => String
  field :full_name, :type => String
  field :password_digest, :type => String
  field :sign_in_count, :type => Integer
  field :username, :type => String
  field :email, :type => String

  has_many :authentications, :dependent => :delete

  auth_key("username")

  def self.create_from_omniauth(auth)
    create! do |user|
      if auth['info']
        user.username ||= auth['info']['username'] || ""
        user.full_name ||= auth['info']['name'] || ""
        user.email ||= auth['info']['email'] || ""
      end
    end
  end

end

