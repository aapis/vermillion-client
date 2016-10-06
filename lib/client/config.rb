module Vermillion
  PACKAGE_NAME = 'vermillion-client'
  INSTALLED_DIR = '/Users/prieber/Work/vermillion-client' #Gem::Specification.find_by_name(Vermillion::PACKAGE_NAME).gem_dir
  HELPER_DIR = INSTALLED_DIR + "/lib/client/helpers/"
  CONTROLLER_DIR = INSTALLED_DIR + "/lib/client/controllers/"
  MODEL_DIR = INSTALLED_DIR + "/lib/client/models/"
  TEMPLATE_DIR = INSTALLED_DIR + "/lib/client/configs/templates/"
  DEBUG = false

  class Cfg
    def bootstrap!
      prepare

      unless valid_config?
        require 'client/controllers/firstrun'

        controller = Vermillion::Controller::Firstrun.new
        controller.default

        prepare
      end
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

    def prepare
      file = File.expand_path("~/.vermillion.yml")
      fmt = Vermillion::Helper.load('formatting')

      if File.exist? file
        @yml = ::YAML.load_file(file)
        # symbolize keys
        @yml = fmt.symbolize(@yml)
      end
    end

    def valid_config?
      !@yml.nil?
    end

    def get(name)
      @yml[name.to_sym]
    end
  end
end
