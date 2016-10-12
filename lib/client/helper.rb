module Vermillion
  module Helper
    # Loads a helper class
    # Params:
    # +klass+:: String representing the class helper subclass you want to load
    # +args+:: Optional arguments to pass to the class instance
    def self.load(klass, args = nil)
      klass_instance = Vermillion::Helper.const_get(klass.capitalize)

      if klass_instance
        if args.nil?
          klass_instance.new
        else
          klass_instance.new(args)
        end
      else
        Notify.error("Class not found: #{klass.capitalize}")
      end
    end
  end
end
