module Vermillion
  PACKAGE_NAME = 'vermillion-client'.freeze
  INSTALLED_DIR = '/Users/prieber/Work/vermillion-client'.freeze # Gem::Specification.find_by_name(Vermillion::PACKAGE_NAME).gem_dir
  HELPER_DIR = INSTALLED_DIR + "/lib/client/helpers/"
  CONTROLLER_DIR = INSTALLED_DIR + "/lib/client/controllers/"
  MODEL_DIR = INSTALLED_DIR + "/lib/client/models/"
  TEMPLATE_DIR = INSTALLED_DIR + "/lib/client/configs/templates/"
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
      keys = Vermillion.constants.select do |name|
        constant? name
      end

      hash = {}
      keys.each do |key|
        hash[key] = Vermillion.const_get(key)
      end
      hash
    end

    def populate_config
      file = File.expand_path("~/.vermillion.yml")
      fmt = Vermillion::Helper.load('formatting')

      return false unless File.exist? file

      @yml = ::YAML.load_file(file)
      @yml = fmt.symbolize(@yml)
    end

    def valid_config?
      !@yml.nil?
    end

    def get(name)
      @yml[name.to_sym]
    end
  end
end
