module Vermillion
  module Controller
    class Update < Controller::Base

      def all
        servers = $config.get(:servers)

        $config.get(:servers).each do |hash|
          srv = hash['address']
          https_endpoint = URI.parse("http://#{srv}")

          begin
            resp = Net::HTTP.get_response(https_endpoint)

            # we don't really care why this failed, just that it did
            raise Errno::ECONNREFUSED if resp.code.to_i > 399

            # handle JSON response
            # JSON.parse(resp.body)
          rescue Errno::ECONNREFUSED => e
            Notify.warning("Request failed for #{https_endpoint}")
          end
        end
      end

      def one(input)
        server = $config.get(:servers).select { |hash| hash['name'] == input }.first
        https_endpoint = URI.parse("http://#{server['address']}")

        begin
          resp = Net::HTTP.get_response(https_endpoint)

          # we don't really care why this failed, just that it did
          raise Errno::ECONNREFUSED if resp.code.to_i > 399
          # handle JSON response
          # JSON.parse(resp.body)
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{https_endpoint}")
        end
      end

    end
  end
end