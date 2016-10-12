module Vermillion
  module Controller
    class Status < Controller::Base
      # Prints both configuration and server information, returns status code 0
      def default
        print_config
        print_servers

        OK
      end

      # Print configuration information
      def config
        print_config
      end

      # Print configured server information
      def servers
        print_servers
      end

      private

      # Process and print config values
      def print_config
        Notify.info("Configuration values")

        @config.options.each_pair do |key, value|
          Notify.spit " - #{key}: #{value}"
        end
      end

      # Process and print server values
      def print_servers
        Notify.info('Sites')

        @config.get(:servers).each do |server|
          Notify.spit(" - Name: #{server[:name]}, Address: #{server[:address]}, HTTPS: #{server[:https]}")
        end
      end
    end
  end
end
