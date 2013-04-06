require 'active_support/concern'

module Growlyflash
  module Controller
    extend ActiveSupport::Concern
    
    included do
      before_filter :flash_to_headers, if: :is_xhr_request?
      
      def flash_to_headers
        flash_json = Hash[ flash.map { |type, msg| [type, msg] } ].to_json
        response.headers['X-Message'] = flash_json
        flash.discard # don't want the flash to appear when you reload page
      end
      
      private
        def is_xhr_request?
          request.xhr?
        end
    end
  end
end