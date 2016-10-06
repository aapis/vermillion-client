module Vermillion
  module Helper
    module ApiCommunication
      def send_to_one(input, endpoint, args = {})
        # setup request values
        server_name = input
        remote_site = nil
        server_name, remote_site, other = input.split('/') if input.include?('/')
        args_qs = ""

        endpoint = "/api/#{endpoint}/"
        server = $config.get(:servers).select { |hash| hash[:name] == server_name }.first

        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server
        # warn user if the site does not have a secret key property set
        return Notify.warning("The server configuration must contain a key property to send requests") unless server[:key]
        # warn user if the user key is not defined
        return Notify.warning("The configuration file must contain a user") unless $config.get(:user)

        http = 'http://'
        http = 'https://' if server[:https]

        begin
          endpoint += remote_site if remote_site
          endpoint += "/#{other}" if other

          # prepare args
          if args.size > 0
            args_qs += "?"
            args.each_pair do |arg, val|
              args_qs += "#{arg}=#{val}"
            end
          end

          resp = @network.post(http + server[:address] + endpoint + args_qs, server[:key])
          puts http + server[:address] + endpoint + args_qs
          # puts resp.body

          # generic failure for invalid response type
          raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

          # handle JSON response
          response_data = @format.symbolize(JSON.parse(resp.body))

          if response_data[:_code] === 200
            Notify.success("#{server_name} (#{server[:address]}) update succeeded")
          else
            Notify.warning("#{response_data[:_title]}: #{response_data[:_message]}")
          end
        rescue Errno::ECONNREFUSED => e
          Notify.warning("Request failed for #{server_name} (#{server[:address]})")
        end
      end

      def send_to_all(endpoint, args)
        servers = @format.symbolize($config.get(:servers))

        $config.get(:servers).each do |server|
          send_to_one(server[:name], endpoint, args) if server[:name]
        end
      end
    end
  end
end