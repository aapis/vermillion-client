module Vermillion
  module Controller
    class Update < Controller::Base
      include Helper::ApiCommunication

      # Update all sites in the manifest
      def all
        send_to_all(:update)
      end

      # Update just one server
      # Params:
      # +server+:: Symbol representing the server you want to update
      def one(server)
        send_to_one(server, :update)
      end

      # Update the configuration manifest for one server
      # Params:
      # +server+:: Symbol representing the server you want to update
      def config(server)
        send_to_one(server, :update_config)
      end
    end
  end
end