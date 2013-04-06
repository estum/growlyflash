if defined?(Rails::Railtie)
  module Growlyflash
    
    class Railtie < ::Rails::Railtie
      # initializer 'growlyflash.active_controller' do
      initializer :growlyflash do
        Growlyflash.initialize
        # ActiveSupport.on_load(:action_controller) do
        #   include Growlyflash::Controller
        # end
      end
    end
  end
end