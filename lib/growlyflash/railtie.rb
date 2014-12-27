require "growlyflash"
require "rails"

module Growlyflash
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load :action_controller do
      include Growlyflash::ControllerAdditions
    end
  end
end