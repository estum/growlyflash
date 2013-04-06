module Growlyflash
  module Helpers
    
    # Insert in head tag in your layout before any js.
    def growlyflash_static_notices
      if flash.any?
        javascript_tag "window.flashes = #{ raw(Hash[ flash.map { |type, msg| [type, msg] } ].to_json) };", defer: 'defer'
      end
    end
  end  
end