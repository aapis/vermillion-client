module Vermillion
  module Controller
    class Update < Controller::Base

      def one(server)
        send_to_one(server, :config)
      end

    end
  end
end