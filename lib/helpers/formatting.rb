module Vermillion
  module Helper
    class Formatting

      #
      # Compatible with
      # http://api.rubyonrails.org/classes/Hash.html#method-i-symbolize_keys
      #
      def symbolize(obj)
        if obj.class == Array
          # obj.map { |k| k.to_sym }
          obj.each do |key|
            #obj[(key.to_sym rescue key) || key] = obj.delete(key)
            if key.class == Hash
              symbolize(key)
            else
              key.map { |k| k.to_sym }
            end
          end
        elsif obj.class == Hash
          obj.keys.each do |key|
            obj[(key.to_sym rescue key) || key] = obj.delete(key)
          end
        end
      end

    end
  end
end
