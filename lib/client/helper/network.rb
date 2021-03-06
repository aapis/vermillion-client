module Vermillion
  module Helper
    class Network
      # Access the configuration object instance externally
      attr_accessor :config

      # Perform a GET request to a specified URL
      # Params:
      # +url+:: The URL you want to hit
      # +key+:: The authentication key to pass via headers to the URL
      def get(url, key)
        _request(url, :GET, key)
      end

      # Perform a POST request to a specified URL
      # Params:
      # +url+:: The URL you want to hit
      # +key+:: The authentication key to pass via headers to the URL
      def post(url, key)
        _request(url, :POST, key)
      end

      private

      # Create and send the HTTP request
      # Params:
      # +url+:: The URL you want to hit
      # +type+:: The HTTP method to send
      # +key+:: The authentication key to pass via headers to the URL
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
