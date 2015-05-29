module Growlyflash
  module ControllerAdditions
    def self.included(base)
      base.module_eval do
        extend ClassMethods
        helper_method :growlyflash_static_notices, :growlyhash
      end
    end

    module ClassMethods
      private

      def use_growlyflash(options = {})
        append_after_filter :flash_to_headers, options.reverse_merge(if: "request.xhr?")
      end

      def skip_growlyflash(options = {})
        skip_after_filter :flash_to_headers, options
      end
    end

    protected

    # Dumps available messages to headers and discards them to prevent appear
    # it again after refreshing a page
    def flash_to_headers
      response.headers['X-Message'] = URI.escape(growlyhash(true).to_json)
      growlyhash.each_key { |k| flash.discard(k) }
    end

    # View helper method which renders flash messages to js variable if they
    # weren't dumped to headers with XHR request
    def growlyflash_static_notices(js_var = 'window.flashes')
      return if flash.empty?
      script = "#{js_var} = #{growlyhash.to_json.html_safe};".freeze
      view_context.javascript_tag(script, defer: 'defer')
    end

    # Hash with available growl flash messages which contains a string object.
    def growlyhash(force = false)
      @growlyhash = nil if force
      @growlyhash ||= flash.to_hash.select { |k, v| v.is_a? String }
    end
  end
end