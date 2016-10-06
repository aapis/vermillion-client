module Vermillion
  module Controller
    class Base
      attr_accessor :model, :helper, :config, :request

      @@options = Hash.new

      # Perform pre-run tasks
      def pre_exec
        @format = Vermillion::Helper.load('formatting')
        @network = Vermillion::Helper.load('network')
        @helper = Vermillion::Helper.const_get(command.capitalize).new rescue nil
        @network.config = @config

        OptionParser.new do |opt|
          opt.banner = "#{Vermillion::PACKAGE_NAME} controller command [...-flags]"

          opt.on("-v", "--verbose", "Verbose output") do |v|
            # short output
            @@options[:verbose] = v
          end

          opt.on("-V", "--version", "Show app version") do |v|
            # short output
            @version = Vermillion::PACKAGE_VERSION
          end
        end.parse!
      end

      # Handle the request
      def exec(args = [])
        if @request.param.nil?
          self.send(@default_method.to_sym)
        else
          self.send(@default_method.to_sym, @request.param)
        end
      end

      # Perform post-run cleanup tasks, such as deleting old logs
      def post_exec(total_errors = 0, total_warnings = 0, total_files = 0)

      end

      # Determines if the command can execute
      def can_exec?(command, controller)
        puts controller.inspect
        puts command.inspect

        exit
        @methods_require_internet = []

        # get user-defined methods to use as a fallback
        user_defined_methods = []

        # timeout is the first system defined method after the user defined
        # ones
        for i in 0..public_methods.index(:to_json) - 1
          user_defined_methods.push(public_methods[i].to_sym)
        end

        @default_method = name || user_defined_methods.first || :sample

        unless respond_to? default_method.to_sym, true
          Notify.error("Command not found: #{name}", show_time: false)
        end

        true
      end

      # default method called by exec if no argument is passed
      def sample
        Notify.warning("Method not implemented");
      end
    end
  end
end
