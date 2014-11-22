module Growlyflash
  class Engine < ::Rails::Engine
    ActiveSupport.on_load :action_controller do
      include Growlyflash::ControllerAdditions
    end
  end
end