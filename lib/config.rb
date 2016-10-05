module Vermillion
  PACKAGE_NAME = 'vermillion-client'
  INSTALLED_DIR = '/Users/prieber/Work/vermillion-client' #Gem::Specification.find_by_name(Vermillion::PACKAGE_NAME).gem_dir
  LOG_DIR = INSTALLED_DIR + "/logs"
  DEFAULT_LOG = Vermillion::Log.new # no args means default log
  HELPER_DIR = INSTALLED_DIR + "/lib/helpers/"
  CONTROLLER_DIR = INSTALLED_DIR + "/lib/controllers/"
  MODEL_DIR = INSTALLED_DIR + "/lib/models/"
  TEMPLATE_DIR = INSTALLED_DIR + "/lib/configs/templates/"
  DEBUG = false

  class Cfg
    @@yml = nil

    def bootstrap!
      begin
        # check if configuration file exists
        if !config_found?
          raise "~/.vermillion.yml not found, this file must be created prior to running"
        end
      rescue => e
        Notify.error("#{e.to_s}", show_time: false)
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

    def config_found?
      file = "#{File.expand_path(Dir.home)}/.vermillion.yml"
      fmt = Vermillion::Helper.load('formatting')

      if File.exists? file
        @@yml = ::YAML.load_file(file)
        # symbolize keys
        #@@yml = @@yml.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        @@yml = fmt.symbolize(@@yml)
      end

      !@@yml.nil?
    end

    def get(name)
      @@yml[name.to_sym]
    end
  end
end
