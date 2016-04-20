module Vermillion
  module Controller
    class Update < Controller::Base

      SERVERS = ['192.168.0.74', 'localhost']

      def all
        SERVERS.each do |srv|
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

      def one(srv)
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
  end
end