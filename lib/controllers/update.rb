module Vermillion
  module Controller
    class Update < Controller::Base

      def all
        $config.get(:servers).each do |dope|
          dope.each_pair do |name, srv|
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

      def one(input)
        puts input.inspect
        exit
        $config.get(:servers).each do |dope|
          dope.each_pair do |name, srv|
            raise ArgumentError, "Invalid server #{input}" if input != name

            https_endpoint = URI.parse("http://#{srv}")

            begin
              resp = Net::HTTP.get_response(https_endpoint)

              # we don't really care why this failed, just that it did
              raise Errno::ECONNREFUSED if resp.code.to_i > 399

              # handle JSON response
              # JSON.parse(resp.body)
            rescue Errno::ECONNREFUSED => e
              Notify.warning("Request failed for #{https_endpoint}")
            rescue ArgumentError => e
              Notify.warning(e.message)
            end
          end
        end
      end

    end
  end
end