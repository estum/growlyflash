# encoding: utf-8

require "growlyflash/version"
require "uri"

module Growlyflash  
  module XMessageHeaders
    def flash_to_headers
      xmessage = URI.escape(Hash[flash].to_json)  # URI escape to fix strange things with headers encoding
      response.headers['X-Message'] = xmessage    
      flash.discard                               # discard flash to prevent it appear again after refreshing page
    end
    
    private
    def is_xhr_request?
      request.xhr?
    end
  end 
  
  module NoticeHelpers
    def growlyflash_static_notices
      return nil unless flash.any?
      javascript_tag "window.flashes = #{raw(Hash[flash].except!(:timedout).to_json)};", defer: 'defer'
    end
  end
  
  class Engine < ::Rails::Engine   
    initializer :growlyflash_xmessage_headers do |config|
      ActionController::Base.class_eval do
        include XMessageHeaders
        helper NoticeHelpers
        after_filter :flash_to_headers, if: :is_xhr_request?
      end
    end
  end
end