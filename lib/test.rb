require 'client'
require 'test/base'

module Vermillion
  # Flag to determine if module is running in test mode
  def self.test?
    true
  end

  # Define Test namespace
  module Test
  end
end