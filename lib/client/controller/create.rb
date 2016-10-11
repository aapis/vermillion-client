module Vermillion
  module Controller
    class Create < Controller::Base
      include Helper::ApiCommunication

      def pre_exec
        OptionParser.new do |opt|
          opt.banner = "#{Vermillion::PACKAGE_NAME} change [...-flags]"

          opt.on("-n", "--name=NAME", "Directory to be created") { |o| @name = o }
        end.parse!

        super
      end

      def one(server, name = nil)
        @name = name || @name
        send_to_one(server, :create, name: @name)
      end
    end
  end
end