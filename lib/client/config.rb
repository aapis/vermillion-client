module Vermillion
  # Flag for enabling more verbose output from certain methods
  DEBUG = false

  class Cfg
    # Perform first run tasks and create or read config file values
    def bootstrap!
      populate_config

      return if valid_config?

      # no config file found, lets create one using the firstrun controller
      require 'client/controller/firstrun'

      controller = Vermillion::Controller::Firstrun.new
      controller.default

      populate_config
    end

    # Returns a hash of all module constants and their values
    def options
      keys = Vermillion.constants.select { |name| constant?(name) }
      hash = {}

      keys.each { |key| hash[key] = Vermillion.const_get(key) }
      hash
    end

    # Populates the internal hash which stores any values set in the config file
    def populate_config
      file = File.expand_path("~/.vermillion.yml")
      fmt = Vermillion::Helper.load('formatting')

      @yml = fmt.symbolize(::YAML.load_file(file))
      self
    end

    # Get a specific value from the config file data
    # Params:
    # +name+:: String/symbol key value
    def get(name)
      @yml[name.to_sym]
    end

    private

    # Check if configuration data exists
    def valid_config?
      !@yml.nil?
    end

    # Checks if string is a constant
    def constant?(name)
      name == name.upcase
    end
  end
end
