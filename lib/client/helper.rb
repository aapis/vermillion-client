module Vermillion
  module Helper
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
