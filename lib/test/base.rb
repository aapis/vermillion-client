require 'minitest/autorun'

module Vermillion
  module Test
    class Base < Minitest::Test
      def setup
        Notify.spit "Executing Tests"
      end
    end
  end
end