module Vermillion
  module Controller
    class Change < Controller::Base
      include Helper::ApiCommunication

      def branch(server)
        send_to_one(server, :change_branch)
      end

    end
  end
end