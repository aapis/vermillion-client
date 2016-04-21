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

            # generic failure for invalid response type
            raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

            # we don't really care why this failed, just that it did
            raise Errno::ECONNREFUSED if resp.code.to_i > 399

            # handle JSON response
            response_data = JSON.parse(resp.body)

            Notify.success("#{response_data['_title']}: #{response_data['_message']}")
          rescue Errno::ECONNREFUSED => e
            Notify.warning("Request failed for #{srv}")
          end
        end
      end

      def one(input)
        server_name, remote_site = input.split('/')
        server = $config.get(:servers).select { |hash| hash['name'] == server_name }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server

        http = 'http://'
        http = 'https://' if server['https']

        begin
          resp = @network.post(http + server['address'] + '/api/update/' + remote_site)
          puts resp.body
          # generic failure for invalid response type
          raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

          # we don't really care why this failed, just that it did
          raise Errno::ECONNREFUSED if resp.code.to_i > 399

          # handle JSON response
          response_data = JSON.parse(resp.body)

          if response_data['_code'] === 200
            Notify.success("#{resp['Host']} updated")
          end
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{server['address']}")
        end
      end

    end
  end
end