module Vermillion
  module Controller
    class Update < Controller::Base

      def all
        servers = $config.get(:servers)

        $config.get(:servers).each do |hash|
          srv = hash['address']
          http = 'http://'
          http = 'https://' if hash['https']

          begin
            resp = @network.post(http + srv + '/api/update')

            # we don't really care why this failed, just that it did
            raise Errno::ECONNREFUSED if resp.code.to_i > 399

            # handle JSON response
            # JSON.parse(resp.body)
          rescue Errno::ECONNREFUSED => e
            Notify.warning("Request failed for #{srv}")
          end
        end
      end

      def one(input)
        server = $config.get(:servers).select { |hash| hash['name'] == input }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{input}") unless server

        http = 'http://'
        http = 'https://' if server['https']

        begin
          resp = @network.post(http + server['address'] + '/api/update')
          puts resp.body
          # we don't really care why this failed, just that it did
          raise Errno::ECONNREFUSED if resp.code.to_i > 399
          # handle JSON response
          # JSON.parse(resp.body)
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{server['address']}")
        end
      end

    end
  end
end