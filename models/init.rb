# encoding: utf-8
require 'mongoid'

Mongoid.load!(::File.expand_path("conf/mongoid.yml", settings.root) )

require_relative 'user'
require_relative 'authentication'
require_relative 'identity'
