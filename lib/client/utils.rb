module Vermillion
  class Utils
    # Convert a hash to a query string
    # Params:
    # +args+:: Hash to convert
    def self.to_query_string(args)
      query_string = "?"

      unless args.empty?
        args.each_pair do |arg, val|
          query_string += "#{arg}=#{val}"
        end
      end

      query_string
    end
  end
end
