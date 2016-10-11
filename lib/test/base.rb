require 'minitest/autorun'

module Vermillion
  module Test
    class Base < Minitest::Test
      MockRequest = Struct.new(:controller, :command)

      def setup
        Notify.spit "Executing Tests (#{Time.now})"
      end
    end
  end
end