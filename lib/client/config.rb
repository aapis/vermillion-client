module Vermillion
  DEBUG = false

  class Cfg
    def bootstrap!
      populate_config

      return if valid_config?

      # no config file found, lets create one using the firstrun controller
      require 'client/controllers/firstrun'

      controller = Vermillion::Controller::Firstrun.new
      controller.default

      populate_config
    end

    def constant?(name)
      name == name.upcase
    end

    def options
      keys = Vermillion.constants.select { |name| constant?(name) }
      hash = {}

      keys.each { |key| hash[key] = Vermillion.const_get(key) }
      hash
    end

    def populate_config
      file = File.expand_path("~/.vermillion.yml")
      fmt = Vermillion::Helper.load('formatting')

      return false unless File.exist? file

      @yml = fmt.symbolize(::YAML.load_file(file))
      self
    end

    def get(name)
      @yml[name.to_sym]
    end

    private

    def valid_config?
      !@yml.nil?
    end
  end
end
