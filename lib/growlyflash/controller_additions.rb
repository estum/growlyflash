module Growlyflash
  module ControllerAdditions
    def self.included(base)
      base.module_eval do
        extend ClassMethods
        if respond_to?(:helper_method)
          helper_method :growlyflash_static_notices, :growlyhash, :growlyflash_tag
        end
      end
    end

    module ClassMethods
      private

      def use_growlyflash(*args)
        append_after_action :flash_to_headers, *args
      end

      def skip_growlyflash(*args)
        skip_after_action :flash_to_headers, *args
      end
    end

    protected

    # Dumps available messages to headers and discards them to prevent appear
    # it again after refreshing a page
    def flash_to_headers
      if request.xhr? && growlyhash(true).size > 0
        response.headers['X-Message'] = URI.escape(growlyhash.to_json)
        growlyhash.each_key { |k| flash.discard(k) }
      end
    end

    # View helper method which renders flash messages to js variable if they
    # weren't dumped to headers with XHR request
    def growlyflash_static_notices(js_var = 'window.flashes')
      return if flash.empty?
      script = "#{js_var} = #{growlyhash.to_json.html_safe};".freeze
      view_context.javascript_tag(script, defer: 'defer')
    end

    # View helper which render a tag with flashes messages in data attribute.
    def growlyflash_tag
      return if flash.empty?
      view_context.tag(
        :div,
        id: 'growlyflash-tag',
        'data-flashes': growlyhash.to_json.html_safe
      )
    end

    # Hash with available growl flash messages which contains a string object.
    def growlyhash(force = false)
      @growlyhash = nil if force
      @growlyhash ||= flash.to_hash.select { |k, v| v.is_a? String }
    end
  end
end
