module Vermillion
  module Helper
    class Network
      attr_accessor :config

      def get(url, key)
        _request(url, :GET, key)
      end

      def post(url, key)
        _request(url, :POST, key)
      end

      private

      def _request(url, type, key)
        url = URI(url)
        type ||= :GET
        req_path = "#{url.path}?#{url.query}"

        if type == :GET
          req = Net::HTTP::Get.new(req_path)
        elsif type == :POST
          req = Net::HTTP::Post.new(req_path)
        end

        req.add_field('X-Vermillion-Key', key)
        req.add_field('Accept', 'application/json')
        req.add_field('Cache-Control', 'no-cache')
        req.add_field('From', @config.get(:user))
        req.add_field('User-Agent', 'Vermillion Client 1.0')

        res = Net::HTTP.new(url.host, url.port).start do |http|
          http.request(req)
        end

        res
      end
    end
  end
end