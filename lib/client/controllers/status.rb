module Vermillion
  module Controller
    class Status < Controller::Base
      def default
        print_config
        print_servers
      end

      def config
        print_config
      end

      def servers
        print_servers
      end

      private

      def print_config
        Notify.info("Configuration values")

        @config.options.each_pair do |key, value|
          Notify.spit " - #{key}: #{value}"
        end
      end

      def print_servers
        Notify.info('Sites')

        @config.get(:servers).each do |server|
          Notify.spit(" - Name: #{server[:name]}, Address: #{server[:address]}, HTTPS: #{server[:https]}")
        end
      end
    end
  end
end
