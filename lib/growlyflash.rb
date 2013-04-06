require "growlyflash/version"
require "growlyflash/controller"

module Growlyflash
  # Your code goes here...
  def self.initialize
    return if @initialized
    raise "ActionController is not available yet." unless defined?(ActionController)
    ActionController::Base.send(:helper, Growlyflash::Helpers)
    ActionController::Base.send(:include, Growlyflash::Controller)
    @initialized = true
  end
end

if defined?(Rails::Railtie)
  require 'growlyflash/railtie'
end