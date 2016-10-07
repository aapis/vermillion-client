module Vermillion
  module Controller
    class Base
      attr_accessor :config, :request

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
      def post_exec(total_errors = 0, total_warnings = 0, total_files = 0)
      end

      # Determines if the command can execute
      def can_exec?(controller, command)
        # respond_to claims known commands do not exist, so lets do this
        # instead
        @method = command if controller.instance_methods.include?(command)
      end

      # default method called by exec if no argument is passed
      def sample
        Notify.warning("Method not implemented")
      end
    end
  end
end
