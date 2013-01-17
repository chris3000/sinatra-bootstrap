require_relative 'modules/simple_scaffold.rb'
require_relative 'modules/tiny_url'
require 'securerandom'

class Emailverify
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include SimpleScaffold
  include TinyUrl
  field :verify_id, :type => String, :default => SecureRandom.uuid.gsub!("-","")
  field :expires_in, :type => Integer, :default => (60*60*24*7) #1 week
  field :expires, :type => Time, :default => Time.now + (60*60*24*7) #1 week from now
  field :small_verify_id, :type => String
  belongs_to :user

  validates_presence_of :verify_id,
                        :message => "Verify ID was not created for some reason."
  validates_uniqueness_of :verify_id,
                          :message => "Verify ID is already taken."

  before_save do |document|
    document.small_verify_id ||= document.small_id
  end

  def small_id
     small_verify_id || TinyUrl.encode(verify_id)
  end

  def self.find_by_small_id small_id
    full_id = TinyUrl.decode(small_id)
    Emailverify.where(verify_id: full_id).first
  end

  def expired?
    Time.now > expires
  end

  def reset_expire
    write_attribute(:expires, (Time.now + expires_in))
    puts "now expires is set to #{expires}"
  end

  #------ scaffold   -------#
  #scaffold stuff
  SimpleScaffold.manage_ignore self, ["_id","_type", "created_at", "updated_at", "user_id"]
  SimpleScaffold.edit_ignore self, ["_id","_type", "created_at", "updated_at", "user_id", "small_verify_id"]
  SimpleScaffold.new_ignore self, ["_id","_type", "created_at", "updated_at", "user_id", "small_verify_id"]
  def human_id
    hid = "verify #{small_id}"
    if user
       hid = hid + " for #{user.human_id}"
    end
  end
  #------ scaffold end -----------#
end
