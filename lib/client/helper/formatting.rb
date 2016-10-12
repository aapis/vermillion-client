module Vermillion
  module Helper
    class Formatting
      # Recursively symbolize keys in a hash
      # Params:
      # +h+:: The hash you want to symbolize
      def symbolize(h)
        case h
        when Hash
          Hash[
            h.map do |k, v|
              [k.respond_to?(:to_sym) ? k.to_sym : k, symbolize(v)]
            end
          ]
        when Enumerable
          h.map { |v| symbolize(v) }
        else
          h
        end
      end
    end
  end
end
