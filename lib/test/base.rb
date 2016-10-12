require 'minitest/autorun'

module Vermillion
  module Test
    class Base < Minitest::Test
      include Vermillion::Controller

      # Struct to mock the actual Request object
      MockRequest = Struct.new(:controller, :command, :param)

      # Perform setup tasks
      def setup
        Notify.spit "Executing Tests (#{Time.now})"
      end
    end
  end
end