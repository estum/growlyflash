require 'bundler/setup'
require 'minitest/autorun'
require 'rails'
require 'growlyflash'
require 'action_controller'

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

ActiveSupport.test_order = :sorted

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(:color => true)

module TestHelper
  Routes = ActionDispatch::Routing::RouteSet.new
  Routes.draw do
    get ':controller(/:action(/:id))'
    get ':controller(/:action)'
  end

  ActionController::Base.send :include, Routes.url_helpers
end

ActionController::TestCase.class_eval do
  def setup
    @routes = TestHelper::Routes
  end
end