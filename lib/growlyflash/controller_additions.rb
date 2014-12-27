require 'active_support/concern'

module Growlyflash
  module ControllerAdditions
    extend ActiveSupport::Concern
    
    included do
      helper_method :growlyflash_static_notices, :growlyhash
    end
    
    module ClassMethods
      private
      def use_growlyflash(options = {})
        append_after_filter :flash_to_headers, options.reverse_merge(if: :is_xhr_request?)
      end
      
      def skip_growlyflash(options = {})
        skip_after_filter :flash_to_headers, options
      end
    end
    
    private
    def is_xhr_request?
      request.xhr?
    end
    
    def flash_to_headers
      response.headers['X-Message'] = URI.escape(growlyhash(true).to_json)
      
      # discard flash to prevent it appear again after refreshing page
      growlyhash.each_key {|k| flash.discard(k) }
    end
    
    def growlyflash_static_notices(js_var = 'window.flashes')
      return nil unless flash.any?
      view_context.javascript_tag "#{js_var} = #{growlyhash.to_json.html_safe};", defer: 'defer'
    end
    
    def growlyhash(force = false)
      @growlyhash = nil if force
      @growlyhash ||= flash.to_hash.select {|k, v| v.is_a? String }
    end
  end
end