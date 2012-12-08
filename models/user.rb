# encoding: utf-8
# Modified from this gist: https://gist.github.com/1353123
#Also, hat tip to: http://blog.eizesus.com/2010/03/creating-a-rails-authentication-system-on-mongoid/

require 'bcrypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps # adds automagic fields created_at, updated_at
  include BCrypt
  #include OmniAuth::Identity::Models::Mongoid

  field :first_name, :type => String
  field :last_name, :type => String
  field :full_name, :type => String
  field :password_digest, :type => String
  field :sign_in_count, :type => Integer
  field :username, :type => String
  field :email, :type => String
  field :accept_terms,  :type => Boolean

  attr_accessor         :password, :password_confirmation
  attr_protected        :password_hash
  #make sure password is encrypted
  #before_save :encrypt_password

  #attr_accessible       :email, :username, :password, :password_confirmation, :errors

  has_many :authentications, :dependent => :delete

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
                        :message => "Email Address is Required."
  validates_uniqueness_of :email,
                          :message => "Email Address Already In Use. Have You Forgot Your Username?"
  validates_format_of :email,
                      :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i,
                      :message => "Please Enter a Valid Email Address."
  validates_acceptance_of :accept_terms,
                          :allow_nil => false,
                          :accept => true,
                          :message => "Terms and Conditions Must Be Accepted."
  validates_length_of :password,
                      :minimum => 8,
                      :message => "Password Must Be Longer Than 8 Characters."
  validates_confirmation_of :password,
                            :message => "Password Confirmation Must Match Given Password."

   # helper methods
   # Encrypts the password into the password_digest attribute.
  def password=(unencrypted_password)
    @password = unencrypted_password
    unless unencrypted_password.empty?
      self.password_digest = Password.create(unencrypted_password)
    end
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
      return user
    else
      return {:error => "Incorrect Password"}
    end

  end

  def self.password_correct?(username, password)

    user_pass == password
  end



=begin
  validates :username,
            :presence => true,
            :uniqueness => true

  validates :email,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
=end

#  auth_key(:username)

end

