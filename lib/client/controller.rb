module Vermillion
  module Controller
    class Base
      attr_accessor :config, :request

      # Exit code to indicate everything is ok!
      OK = 0
      # Exit code to indicate a force quit (exit) call, meaning the program
      # quit with an error
      QUIT = 1
      # Exit code to indicate that the program exited with a non-zero exit code,
      # but not one that resulted in a force quit
      QUIT_SOFT = 2

      def initialize(config, request)
        @config = config
        @request = request

        pre_exec
      end

      # Perform pre-run tasks
      def pre_exec
        @format = Vermillion::Helper.load('formatting')
        @network = Vermillion::Helper.load('network')
        @network.config = @config
      end

      # Handle the request
      def exec
        raise NoMethodError, "Method cannot be nil" unless @method

        if @request.param.nil?
          send(@method.to_sym)
        else
          send(@method.to_sym, @request.param)
        end
      end

      # Perform post-run cleanup tasks, such as deleting old logs
      def post_exec
      end

      # Determines if the command can execute
      def can_exec?(command)
        # no command was passed, check if controller has a default method
        if command.nil? && respond_to?(:default)
          @method = :default
        elsif respond_to? command
          # check the controller for the requested method
          @method = command
        end
      end

      # default method called by exec if no argument is passed
      def sample
        Notify.warning("Method not implemented")
      end
    end
  end
end
