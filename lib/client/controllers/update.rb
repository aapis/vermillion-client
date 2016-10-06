module Vermillion
  module Controller
    class Update < Controller::Base
      include Helper::ApiCommunication

      def all
        send_to_all(:update)
      end

      def one(server)
        send_to_one(server, :update)
      end

      def config(server)
        send_to_one(server, :update_config)
      end
    end
  end
end