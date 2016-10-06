module Vermillion
  class Utils
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
