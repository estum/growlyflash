# encoding: utf-8
require "growlyflash/version"

module Growlyflash
  class << self
    def logger
      @@logger ||= nil
    end

    def logger=(logger)
      @@logger = logger
    end
  end
  
  module XMessageHeaders
    def flash_to_headers
      response.headers['X-Message'] = JSON.generate Hash[flash].as_json
      flash.discard # don't want the flash to appear when you reload page
    end
    
    private
      def is_xhr_request?
        request.xhr?
      end
  end
  
  module NoticeHelpers
    def growlyflash_static_notices
      if flash.any?
        javascript_tag "window.flashes = #{ raw(Hash[ flash.map { |type, msg| [type, msg] } ].to_json) };", defer: 'defer'
      end
    end
  end
  
  class Engine < ::Rails::Engine
    initializer :growlyflash_xmessage_headers do |config|
      Growlyflash.logger = ::Rails.logger
      ActionController::Base.class_eval do
        helper NoticeHelpers
        include XMessageHeaders

        after_filter :flash_to_headers, if: :is_xhr_request?
      end
    end
  end
end

# if defined?(Rails)
#   require 'growlyflash/engine'
# end
# 
# if defined?(Rails::Railtie)
# end