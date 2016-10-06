module Vermillion
  class Router

    def pre_exec
      # Populate request params
      $request = Request.new

      # include the controller
      if File.exists? "#{Vermillion::CONTROLLER_DIR}#{$request.controller}.rb"
        require "#{Vermillion::CONTROLLER_DIR}#{$request.controller}.rb"
      end

      # include helpers
      if File.exists? "#{Vermillion::HELPER_DIR}#{$request.controller}.rb"
        require "#{Vermillion::HELPER_DIR}#{$request.controller}.rb"
      end
    end

    def route
      pre_exec

      # Create object context and pass it the required command line arguments
      begin
        if !$request.controller.nil?
          controller = Vermillion::Controller.const_get $request.controller.capitalize rescue false

          if !controller
            raise "Controller not found: #{$request.controller.capitalize}"
          end

          context = controller.new

          if context.can_exec? $request.controller, $request.command
            context.pre_exec

            if context.methods_require_internet.include? $request.command
              if !Utils.has_internet_connection?
                raise RuntimeError, "Command `#{Vermillion::PACKAGE_NAME} #{$request.controller} #{$request.command}` requires a connection to the internet.\nPlease check your network configuration settings."
              end
            end

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
      rescue RuntimeError => e
        Notify.error("#{e.to_s}", show_time: false)
      rescue NameError => e
        Notify.error("#{e.to_s}\n#{e.backtrace.join("\n")}", show_time: false)
      end
    end

  end
end