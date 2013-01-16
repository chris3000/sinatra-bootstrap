# encoding: utf-8

require_relative 'mailer'
#configure mailer
email_cred = YAML.load_file(File.expand_path("conf/email.yml", settings.root))
gmail_cred = email_cred["gmail"].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}  #symbolize keys
Mailer.add_service("gmail", gmail_cred)
MyApp.helpers Mailer

require_relative 'partials'
MyApp.helpers PartialPartials

require_relative 'nicebytes'
MyApp.helpers NiceBytes
