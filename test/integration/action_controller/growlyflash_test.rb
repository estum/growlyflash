require 'test_helper'

module ActionController
  module Growlyflash
    class IntegrationTest < ActionController::TestCase
      class MyController < ActionController::Base
        use_growlyflash
        skip_growlyflash only: [:xhr_skip_growlyflash]
        
        def xhr_use_growlyflash
          flash.notice = "Growlyflash!"
          flash[:timedout] = true
          render json: '{}'
        end
        
        def xhr_skip_growlyflash
          flash.notice = "Growlyflash!"
          render json: '{}'
        end
      end
      
      tests MyController

      def call_xhr_action(action)
        if Rails::VERSION::MAJOR < 5
          xhr :get, action
        else
          get action, xhr: true
        end
      end
      
      def test_xhr_use_growlyflash
        call_xhr_action :xhr_use_growlyflash
        
        assert_response 200
        refute_nil @response.headers['X-Message']
        assert_equal '{"notice":"Growlyflash!"}', URI.decode_www_form_component(@response.headers['X-Message'])
      end
      
      def test_xhr_skip_growlyflash
        call_xhr_action :xhr_skip_growlyflash

        assert_response 200
        assert_nil @response.headers['X-Message']
      end
    end
  end
end