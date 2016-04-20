module Vermillion
  module Helper
    class Network

      def request(url)
        url = URI(url)
        resp = Net::HTTP.get_response(url)
      end
      
    end
  end
end
