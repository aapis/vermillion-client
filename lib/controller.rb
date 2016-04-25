module Vermillion
  module Controller
    class Base
      attr_accessor :model, :helper, :methods_require_internet, :default_method

      @@options = Hash.new
      
      # Perform pre-run tasks
      def pre_exec
        @format = Vermillion::Helper.load('formatting')
        @network = Vermillion::Helper.load('network')

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
        if $request.param.nil?
          self.send(@default_method.to_sym)
        else
          self.send(@default_method.to_sym, $request.param)
        end
      end

      # Perform post-run cleanup tasks, such as deleting old logs
      def post_exec(total_errors = 0, total_warnings = 0, total_files = 0)
        
      end

      # Determines if the command can execute
      def can_exec?(command = nil, name = nil)
        @model = Vermillion::Model.const_get(command.capitalize).new rescue nil
        @helper = Vermillion::Helper.const_get(command.capitalize).new rescue nil
        @methods_require_internet = []

        # get user-defined methods to use as a fallback
        user_defined_methods = []

        # timeout is the first system defined method after the user defined
        # ones
        for i in 0..public_methods.index(:to_json) -1
          user_defined_methods.push(public_methods[i].to_sym)
        end

        @default_method = name || user_defined_methods.first || :sample

        if !respond_to? default_method.to_sym, true
          Notify.error("Command not found: #{name}", show_time: false)
        end

        true
      end

      # default method called by exec if no argument is passed
      def sample
        Notify.warning("Method not implemented");
      end

      def required_modules(*modules)
        auto_load_required(modules).each do |type, hash|
          # Make each auto-loaded module available as an instance variable
          # i.e. [:hound]: @hound_controller, @hound_model, @hound_helper
          # i.e. [:test]: @test_controller, @test_model, @test_helper
          # Only files that exist and can be called are loaded
          hash.each do |key, value|
            instance_variable_set("@#{key}_#{type}".to_sym, value)
            @last_model = instance_variable_get("@#{key}_model")
          end
        end
      end

      protected
      def send_to_one(input, endpoint)
        # setup request values
        server_name = input
        remote_site = nil
        server_name, remote_site, other = input.split('/') if input.include?('/')

        endpoint = "/api/#{endpoint}/"

        server = $config.get(:servers).select { |hash| hash['name'] == server_name }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server
        # warn user if the site does not have a secret key property set
        return Notify.warning("The server configuration must contain a key property to send requests") unless server['key']
        # warn user if the user key is not defined
        return Notify.warning("The configuration file must contain a user") unless $config.get(:user)

        http = 'http://'
        http = 'https://' if server['https']

        begin
          endpoint += remote_site if remote_site
          endpoint += "/#{other}" if other
          resp = @network.post(http + server['address'] + endpoint, server['key'])
          puts resp.body

          # generic failure for invalid response type
          raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

          # we don't really care why this failed, just that it did
          raise Errno::ECONNREFUSED if resp.code.to_i > 399

          # handle JSON response
          response_data = JSON.parse(resp.body)

          if response_data['_code'] === 200
            Notify.success("#{resp['Host']} updated")
          end
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{server['address']}")
        end
      end

      protected
      def send_to_all(endpoint)
        servers = $config.get(:servers)
        endpoint = "/api/#{endpoint}"

        $config.get(:servers).each do |server|
          srv = server['address']
          http = 'http://'
          http = 'https://' if server['https']

          # warn user if the server is not defined
          return Notify.warning("Server not found: #{server['name']}") unless server['name']
          # warn user if the site does not have a secret key property set
          return Notify.warning("The server configuration must contain a key property to send requests") unless server['key']
          # warn user if the user key is not defined
          return Notify.warning("The configuration file must contain a user") unless $config.get(:user)

          begin
            resp = @network.post(http + srv + endpoint, server['key'])

            # generic failure for invalid response type
            raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

            # we don't really care why this failed, just that it did
            raise Errno::ECONNREFUSED if resp.code.to_i > 399

            # handle JSON response
            response_data = JSON.parse(resp.body)

            if response_data['_code'] === 200
              Notify.success("#{resp['Host']} updated")
            end
          rescue Errno::ECONNREFUSED => e
            Notify.warning("Request failed for #{srv}")
          end
        end
      end

      private

      # autoload and instantiate required libraries, models and helpers
      def auto_load_required(modules = [])
        loaded = {:controller => {}, :helper => {}, :model => {}}
        
        begin
          modules.each do |mod|
            if File.exists? "#{Vermillion::INSTALLED_DIR}/lib/controllers/#{mod}.rb"
              require "#{Vermillion::INSTALLED_DIR}/lib/controllers/#{mod}.rb"
              
              loaded[:controller][mod] = Vermillion::Controller.const_get(mod.capitalize).new
            else
              raise StandardError, "Controller not found: #{mod}"
            end

            if File.exists? "#{Vermillion::INSTALLED_DIR}/lib/helpers/#{mod}.rb"
              require "#{Vermillion::INSTALLED_DIR}/lib/helpers/#{mod}.rb"
              loaded[:helper][mod] = Vermillion::Helper.const_get(mod.capitalize).new

              # auto-instantiate new instance of helper for the new instance of the controller
              loaded[:controller][mod].helper = loaded[:helper][mod]
            end

            if File.exists? "#{Vermillion::INSTALLED_DIR}/lib/models/#{mod}.rb"
              require "#{Vermillion::INSTALLED_DIR}/lib/models/#{mod}.rb"
              loaded[:model][mod] = Vermillion::Model.const_get(mod.capitalize).new

              # auto-instantiate new instance of model for the new instance of the controller
              loaded[:controller][mod].model = loaded[:model][mod]
            else
              loaded[:controller][mod].model = Model::Base.new
            end
          end

          loaded
        rescue StandardError => e
          Notify.error(e.message, show_time: false)
        end
      end
    end
  end
end
