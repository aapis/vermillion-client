module Vermillion
  module Controller
    class Update < Controller::Base

      def all
        _send_to_all(:update)
      end

      def one(server)
        _send_to_one(server, :update)
      end

      def config(server)
        _send_to_one(server, :update_config)
      end

      private

      def _send_to_one(input, endpoint)
        # setup request values
        server_name = input
        remote_site = nil
        server_name, remote_site = input.split('/') if input.include?('/')
        endpoint = "/api/#{endpoint}/"

        server = $config.get(:servers).select { |hash| hash['name'] == server_name }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server
        # warn user if the site does not have a secret key property set
        return Notify.warning("The server configuration must contain a key property to send requests") unless server['key']

        http = 'http://'
        http = 'https://' if server['https']

        begin
          endpoint = api_endpoint + remote_site if remote_site
          resp = @network.post(http + server['address'] + endpoint, server['key'])
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

      def _send_to_all(endpoint)
        servers = $config.get(:servers)
        endpoint = "/api/#{endpoint}"

        $config.get(:servers).each do |hash|
          srv = hash['address']
          http = 'http://'
          http = 'https://' if hash['https']

          begin
            resp = @network.post(http + srv + endpoint, server['key'])

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
            Notify.warning("Request failed for #{srv}")
          end
        end
      end

    end
  end
end