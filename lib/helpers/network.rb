module Vermillion
  module Helper
    class Network

      def get(url)
        _request(url, :GET)
      end

      def post(url)
        _request(url, :POST)
      end

      private

      def _verify(secret)

      end

      def _request(url, type = :GET)
        url = URI(url)

        if type == :GET
          req = Net::HTTP::Get.new(url.path)
        elsif type == :POST
          req = Net::HTTP::Post.new(url.path)
        end

        req.add_field('X-Vermillion-Key', $config.get(:key))

        res = Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req)
        end

        res
      end
      
    end
  end
end
