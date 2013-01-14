# encoding: utf-8
# Modified from this gist: https://gist.github.com/1353123
#Also, hat tip to: http://blog.eizesus.com/2010/03/creating-a-rails-authentication-system-on-mongoid/

require 'bcrypt'
require_relative 'simple_scaffold.rb'
class User

  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include BCrypt
  include SimpleScaffold
  #include OmniAuth::Identity::Models::Mongoid

  field :first_name, :type => String
  field :last_name, :type => String
  field :full_name, :type => String
  field :password_digest, :type => String
  field :sign_in_count, :type => Integer, default: 1
  field :username, :type => String
  field :email, :type => String
  field :accept_terms,  :type => Boolean, default: false
  field :verified, :type => Boolean, default: false

  attr_accessor         :password, :password_confirmation
  attr_protected        :password_hash
  attr_readonly         :username
  has_many :authentications, :dependent => :delete
  has_many :things, :dependent => :delete
  #belongs_to :something
  #has_and_belongs_to_many :something_else
  #validations
  validates_presence_of :username,
                        :message => "Username is Required."
  validates_uniqueness_of :username,
                          :message => "That Username is taken.  Please try another."
  validates_length_of :username,
                      :minimum => 3,
                      :maximum => 16,
                      :message => "Usernames must be between 3 and 16 characters"
  validates_format_of :username,
                      :with => /^[-\w\._]+$/i,
                      :message => "should only contain letters, numbers, '.', '-', or '_'"
  validates_presence_of :email,
                        :message => "Email address is required."
  validates_uniqueness_of :email,
                          :message => "Email address is already in use. Have you forgotten your Username?"
  validates_format_of :email,
                      :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
                      :message => "Please enter a valid Email Address."
  validates_acceptance_of :accept_terms,
                          :allow_nil => false,
                          :accept => true,
                          :message => "Terms and Conditions Must Be Accepted."
  validates_length_of :password,
                      :if => :password_changed?,
                      :minimum => 7,
                      :message => "Password must be at least 7 characters."
  validates_confirmation_of :password,
                           :if => :password_changed?,
                            :message => "Password confirmation must match given password."

  #scaffold stuff
  SimpleScaffold.manage_ignore self, ["password_digest", "accept_terms", "_id","_type", "created_at", "updated_at", "first_name", "last_name", "full_name"]
  SimpleScaffold.edit_ignore self, ["password_digest", "_id","_type", "created_at", "updated_at"]
  SimpleScaffold.edit_add self, [{:field=>"password", :type => String}, {:field=>"password_confirmation", :type => String}]
  SimpleScaffold.new_add self, [{:field=>"password", :type => String}, {:field=>"password_confirmation", :type => String}]

  def human_id
    username
  end

  def password_changed?
    !@password.blank?
  end

=begin

  def self.scaffold_manage
    all_field_names = self.fields.keys
    remove_list = ["password_digest", "accept_terms",
                   "_id","_type",
                   "created_at",
                   "updated_at",
                    "first_name", "last_name",
                    "full_name"]
    remove_list.each do |remove_field|
     all_field_names.delete remove_field
    end
    all_field_names << "authentications"
    all_field_names
  end
=end

   # helper methods
   # Encrypts the password into the password_digest attribute.
  def password=(unencrypted_password)
    if !(unencrypted_password.is_a? String) || unencrypted_password.empty? || unencrypted_password.nil?
      unencrypted_password = "a"
    end
    @password = unencrypted_password
    self.password_digest = Password.create(unencrypted_password)
  end

  def verified?
    verified
  end

  def self.find_by_username(username)
    usr = nil
    begin
    usr = find_by( username: username)
    rescue
      #bail
    end
    usr
  end

  #return user if username and password are correct.
  #return error hash if something went wrong
  def self.authenticate(username, password)
    user = find_by_username username
    return {:error => "User not found"}if user.nil?

    user_pass = Password.new(user.password_digest)
    if user_pass == password
      user.increment_signin_count
      return user
    else
      return {:error => "Incorrect Password"}
    end

  end

  def increment_signin_count
    inc(:sign_in_count,1)
  end

  def self.password_correct?(username, password)

    user_pass == password
  end

end

