module Vermillion
  module Controller
    class Change < Controller::Base
      include Helper::ApiCommunication

      def pre_exec
        OptionParser.new do |opt|
          opt.banner = "#{Vermillion::PACKAGE_NAME} change [...-flags]"

          opt.on("-t", "--to=TO", "Branch to change to") { |o| @to = o }
        end.parse!

        super
      end

      def branch(server, to = nil)
        @to = to || @to
        send_to_one(server, :change_branch, to: @to)
      end
    end
  end
end