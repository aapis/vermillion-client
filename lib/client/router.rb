module Vermillion
  class Router
    def initialize(config_instance)
      @config = config_instance
    end

    def pre_exec
      # Populate request params
      @request = Request.new

      begin
        # include the controller
        require "client/controllers/#{@request.controller}"
        # include helpers
        require "client/helpers/#{@request.controller}" if File.exist? "client/helpers/#{@request.controller}"
      rescue LoadError
        Notify.error("Controller not found: #{@request.controller}")
      end
    end

    def route
      pre_exec

      # Create object context and pass it the required command line arguments
      begin
        unless @request.controller.nil?
          controller = Vermillion::Controller.const_get @request.controller.capitalize

          # create an instance of the requested controller
          context = controller.new(@config, @request)

          if context.can_exec? @request.command
            # Set things up
            context.pre_exec

            # Run the requested action
            context.exec

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
