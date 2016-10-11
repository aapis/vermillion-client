module Vermillion
  class Router
    def initialize(config_instance)
      @config = config_instance
    end

    def pre_exec
      # Populate request params
      @request = Request.new

      # include the controller
      require "#{Vermillion::CONTROLLER_DIR}#{@request.controller}.rb" if File.exist? "#{Vermillion::CONTROLLER_DIR}#{@request.controller}.rb"

      # include helpers
      require "#{Vermillion::HELPER_DIR}#{@request.controller}.rb" if File.exist? "#{Vermillion::HELPER_DIR}#{@request.controller}.rb"
    end

    def route
      pre_exec

      # Create object context and pass it the required command line arguments
      begin
        unless @request.controller.nil?
          controller = Vermillion::Controller.const_get @request.controller.capitalize

          raise "Controller not found: #{@request.controller.capitalize}" unless controller

          context = controller.new

          # bind some object instances to the controller so they are available
          # later (such as, in the requested controller!)
          context.config = @config
          context.request = @request

          if context.can_exec? controller, @request.command
            context.pre_exec

            # Run the controller
            # Call a default action for controllers which do not require a third
            # argument, i.e. COMMAND status
            if context.respond_to? :default
              context.default
            else
              context.exec
            end

            # Run cleanup commands
            context.post_exec
          end
        end
      rescue NoMethodError => e
        Notify.error(e.message)
      rescue RuntimeError => e
        Notify.error(e.message, show_time: false)
      rescue NameError => e
        Notify.error("#{e}\n#{e.backtrace.join("\n")}", show_time: false)
      end
    end
  end
end
