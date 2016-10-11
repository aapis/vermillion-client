require 'minitest/autorun'

module Vermillion
  module Test
    class Base < Minitest::Test
      include Vermillion::Controller

      MockRequest = Struct.new(:controller, :command, :param)

      def setup
        Notify.spit "Executing Tests (#{Time.now})"
      end
    end
  end
end