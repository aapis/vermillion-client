module Vermillion
  module Helper
    class Network

      def request(url)
        url = URI(url)
        req = Net::HTTP::Get.new(url.path)
        req.add_field('X-Vermillion-Key', $config.get(:key))

        res = Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req)
        end

        res
      end
      
    end
  end
end
