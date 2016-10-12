module Vermillion
  module Controller
    class Change < Controller::Base
      include Helper::ApiCommunication

      # Prepare to execute the requested method
      def pre_exec
        OptionParser.new do |opt|
          opt.banner = "vermillion change [...-flags]"

          opt.on("-t", "--to=TO", "Branch to change to") { |o| @to = o }
        end.parse!

        super
      end

      # Change branches on the selected server
      # +server+:: Symbol representing the server you want to access
      # +to+:: Optional symbol, what branch should we change to?
      def branch(server, to = nil)
        @to = to || @to
        send_to_one(server, :change_branch, to: @to)
      end
    end
  end
end