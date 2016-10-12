module Vermillion
  module Helper
    class Endpoint
      attr_writer :server

      # Creates the Endpoint object with default values for internal variables
      # Params:
      # +initial_path+:: Starting point of the URL this class will build
      def initialize(initial_path)
        @path = { default: initial_path }
        @server = nil
        @protocol = "http://"
      end

      # Set endpoint protocol
      # Params:
      # +use_https+:: Boolean value for whether to use HTTPS
      def protocol=(use_https)
        @protocol = 'https://' if use_https
      end

      # Add a section to the path
      # Params:
      # +key+:: Symbol, the key to identify the section
      # +value+:: Any value to store with the associated key
      def add(key, value)
        @path[key.to_sym] = value
      end

      # Return a value based on the provided key
      # Params:
      # +key+:: Symbol, the key to identify the section
      def get(key)
        @path[key.to_sym]
      end

      # Deletes a value from the internal hash based on a key
      # Params:
      # +key+:: Symbol, the key to identify the section
      def delete(key)
        @path.delete(key)
      end

      # Checks whether a key exists
      # Params:
      # +key+:: Symbol, the key to identify the section
      def exists?(key)
        @path.key? key
      end

      # Override the to_s method to return an endpoint fragment
      def to_s
        output = @protocol + @server
        @path.each_pair do |_k, value|
          output += value
        end
        output
      end
    end
  end
end