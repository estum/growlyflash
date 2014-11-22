require 'active_support/concern'

module Growlyflash
  module ControllerAdditions
    extend ActiveSupport::Concern
    
    included do
      helper_method :growlyflash_static_notices
    end
    
    private    
    def is_xhr_request?
      request.xhr?
    end
    
    def flash_to_headers
      _text_flashes = text_flashes
      response.headers['X-Message'] = URI.escape(_text_flashes.to_json)
      
      # discard flash to prevent it appear again after refreshing page
      _text_flashes.each_key {|k| flash.discard(k) }
    end
    
    def growlyflash_static_notices
      return nil unless flash.any?
      view_context.javascript_tag "window.flashes = #{text_flashes.except!(:timedout, 'timedout').to_json.html_safe};", defer: 'defer'
    end
    
    def text_flashes
      flash.to_hash.select {|k, v| v.is_a? String }
    end
  end
end