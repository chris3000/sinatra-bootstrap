module Mailer
  require 'pony'

  class << self
    def add_service(unique_name, email_service)
      @services ||= {}
      if email_service.is_a? MailService
        new_service = email_service
      elsif email_service.is_a? Hash
        new_service = MailService.new email_service
      end
      @services[unique_name.to_sym] = new_service
    end

    def has_service? service_name
        @services.has_key? service_name.to_sym
    end

    def services
      @services
    end

    def send(service_name, email_instance, delivery_api=:pony)
      mail_service = @services[service_name.to_sym]
      if mail_service.nil?
        return "Email service '#{service_name}' was not found"
      end
      if email_instance.is_a? EmailInstance
        email_instance_hash = email_instance.get_pony_options
      elsif email_instance.is_a? Hash
        email_instance_hash =  email_instance
      end
      if email_instance_hash

      if delivery_api == :pony
        return send_pony mail_service.get_pony_options, email_instance_hash
      end
      else
        return "Email instance info must be a hash or an EmailInstance object"
      end
    end

    private
    def send_pony(email_service_hash, email_instance_hash)
      opts = email_instance_hash
      opts[:via_options] = email_service_hash
      puts opts.inspect
      Pony.mail(opts)
    end
  end
end

class EmailInstance
  attr_accessor :via, :to, :cc, :bcc, :from, :body, :html_body,:subject, :charset, :text_part_charset, :attachments, :headers, :message_id, :sender, :reply_to

  def set_defaults
    @via = 'smtp'
  end

  def initialize(params={})
    set_defaults
    params.each do |param, value|
      var_str = "@#{param.to_s}"
      instance_variable_set(var_str, value)
    end
  end
  def get_pony_options
    pony_opts = {}
    instance_variables.each do |variable|
      pony_opts[variable.to_s.gsub('@','').to_sym] = instance_variable_get("#{variable}")
    end
    pony_opts
  end
end

class MailService
  attr_accessor :address,:port, :enable_starttls_auto, :user_name, :password, :authentication, :domain

  def set_defaults
    @address= 'smtp.gmail.com'
    @port= '587'
    @enable_starttls_auto=  true
    @authentication= :plain
    @domain= "localhost.localdomain"
  end

  def initialize(params={})
    set_defaults
    params.each do |param, value|
      var_str = "@#{param.to_s}"
      instance_variable_set(var_str, value)
    end
  end

  def get_pony_options
    pony_opts = {}
     instance_variables.each do |variable|
       pony_opts[variable.to_s.gsub('@','').to_sym] = instance_variable_get("#{variable}")
     end
    pony_opts
  end
end

