module Vermillion
  module Helper
    def self.load(klass, args = nil)
      begin
        klass_instance = Vermillion::Helper.const_get(klass.capitalize)
        
        if klass_instance
          if args.nil?
            klass_instance.new
          else
            klass_instance.new(args)
          end
        end
      rescue => e
        Notify.error(e.message)
      end
    end
  end
end
