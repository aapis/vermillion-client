module Vermillion
  module Helper
    class Network

      def get(url, key)
        _request(url, :GET, key)
      end

      def post(url, key)
        _request(url, :POST, key)
      end

      private

      def _request(url, type = :GET, key)
        url = URI(url)

        if type == :GET
          req = Net::HTTP::Get.new(url.path)
        elsif type == :POST
          req = Net::HTTP::Post.new(url.path)
        end

        req.add_field('X-Vermillion-Key', key)
        req.add_field('Accept', 'application/json')
        req.add_field('Cache-Control', 'no-cache')
        req.add_field('From', $config.get(:user))
        req.add_field('User-Agent', 'Vermillion Client 1.0')

        res = Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req)
        end

        res
      end
      
    end
  end
end
