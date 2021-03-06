module Vermillion
  module Controller
    class Create < Controller::Base
      include Helper::ApiCommunication

      # Prepare to execute the requested method
      def pre_exec
        OptionParser.new do |opt|
          opt.banner = "vermillion create [...-flags]"

          opt.on("-n", "--name=NAME", "Directory to be created") { |o| @name = o }
        end.parse!

        super
      end

      # Create a new project on the requested server
      # +server+:: Symbol representing the server you want to access
      # +name+:: Optional symbol, the name of the project
      def one(server, name = nil)
        @name = name || @name
        send_to_one(server, :create, name: @name)
      end
    end
  end
end