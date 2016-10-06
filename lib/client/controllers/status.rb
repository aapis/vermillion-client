module Vermillion
  module Controller
    class Status < Controller::Base
      def default
        Notify.info("Configuration values")
        @config.options.each_pair do |key, value|
          Notify.spit " - #{key}: #{value}"
        end

        Notify.info('Sites')
        @config.get(:servers).each do |server|
          Notify.spit(" - Name: #{server[:name]}, Address: #{server[:address]}, HTTPS: #{server[:https].to_bool}")
        end
      end
    end
  end
end
