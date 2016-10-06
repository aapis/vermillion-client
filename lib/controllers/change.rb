module Vermillion
  module Controller
    class Change < Controller::Base
      include Helper::ApiCommunication

      def pre_exec
        OptionParser.new do |opt|
          opt.banner = "#{Vermillion::PACKAGE_NAME} change [...-flags]"

          opt.on("-t", "--to=TO", "Branch to change to") do |v|
            @to = v
          end
        end.parse!

        super
      end

      def branch(server)
        send_to_one(server, :change_branch, { to: @to })
      end
    end
  end
end