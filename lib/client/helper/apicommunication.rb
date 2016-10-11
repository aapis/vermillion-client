module Vermillion
  module Helper
    module ApiCommunication
      def send_to_one(input, endpoint, args = {})
        # setup request values
        server, endpoint = setup(input, endpoint, args)

        begin
          resp = @network.post(endpoint.to_s, server[:key])
          # puts http + server[:address] + endpoint + args_qs
          # puts resp.body

          # generic failure for invalid response type
          raise Errno::ECONNREFUSED if resp["Content-Type"] != "application/json"

          # handle JSON response
          response_data = @format.symbolize(JSON.parse(resp.body))

          if response_data[:_code] == 200
            Notify.success("#{server[:name]} (#{server[:address]}) update succeeded")
          elsif !response_data[:message].nil?
            # work around a messaging issue with vermillion-server
            Notify.warning("Error: #{response_data[:message]}")
          else
            Notify.warning("#{response_data[:_title]}: #{response_data[:_message]}")
          end
        rescue Errno::ECONNREFUSED
          Notify.warning("Request failed for #{server[:name]} (#{server[:address]})")
        end
      end

      def send_to_all(endpoint, args)
        @config.get(:servers).each do |server|
          send_to_one(server[:name], endpoint, args) if server[:name]
        end
      end

      private

      def setup(input, endpoint, args = {})
        server_name = input
        remote_site = nil
        server_name, remote_site, other = input.split('/') if input.to_s.include?('/')

        server = @config.get(:servers).select { |hash| hash[:name].to_sym == server_name.to_sym }.first
        # warn user if the server is not defined
        return Notify.warning("Server not found: #{server_name}") unless server
        # warn user if the site does not have a secret key property set
        return Notify.warning("The server configuration must contain a key property to send requests") unless server[:key]
        # warn user if the user key is not defined
        return Notify.warning("The configuration file must contain a user") unless @config.get(:user)

        endpoint = Endpoint.new("/api/#{endpoint}/")
        endpoint.server = server[:address]
        endpoint.protocol = server[:https]
        endpoint.add(:remote, remote_site) if remote_site
        endpoint.add(:other, "/#{other}") if other
        endpoint.add(:query_string, Utils.to_query_string(args))

        [server, endpoint]
      end
    end
  end
end