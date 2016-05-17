module Vermillion
  module Helper
    module ApiCommunication

      def send_to_one(input, endpoint)
        # setup request values
        server_name = input
        remote_site = nil
        server_name, remote_site, other = input.split('/') if input.include?('/')

        endpoint = "/api/#{endpoint}/"
        server = $config.get(:servers).select { |hash| hash[:name] == server_name }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server
        # warn user if the site does not have a secret key property set
        return Notify.warning("The server configuration must contain a key property to send requests") unless server[:key]
        # warn user if the user key is not defined
        return Notify.warning("The configuration file must contain a user") unless $config.get(:user)

        http = 'http://'
        http = 'https://' if server['https']

        begin
          endpoint += remote_site if remote_site
          endpoint += "/#{other}" if other
          resp = @network.post(http + server[:address] + endpoint, server[:key])
          # puts http + server[:address] + endpoint
          puts resp.body

          # generic failure for invalid response type
          raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

          # we don't really care why this failed, just that it did
          raise Errno::ECONNREFUSED if resp.code.to_i > 399

          # handle JSON response
          response_data = @format.symbolize(JSON.parse(resp.body))
          puts response_data.inspect

          if response_data['_code'] === 200
            Notify.success("#{server_name} (#{server[:address]}) updated")
          end
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{server_name} (#{server[:address]})")
        end
      end

      def send_to_all(endpoint)
        servers = @format.symbolize($config.get(:servers))

        $config.get(:servers).each do |server|
          send_to_one(server[:name], endpoint) if server[:name]
        end
      end

    end
  end
end