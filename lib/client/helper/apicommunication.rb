module Vermillion
  module Helper
    module ApiCommunication
      # Send an HTTP request to one server
      # Params:
      # +input+:: The server you want to connect to
      # +endpoint+:: The REST endpoint you'd like to send a request to
      # +args+:: Any specific configuration data to send along with the request
      def send_to_one(input, endpoint, args = {})
        server, endpoint = setup(input, endpoint, args)

        begin
          resp = @network.post(endpoint.to_s, server[:key])

          Notify.spit(endpoint.to_s) if DEBUG
          Notify.spit(resp.body) if DEBUG

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

      # Send HTTP requests to all servers in the local manifest
      # Params:
      # +endpoint+:: The REST endpoint you'd like to send a request to
      # +args+:: Any specific configuration data to send along with the request
      def send_to_all(endpoint, args = {})
        @config.get(:servers).each do |server|
          send_to_one(server[:name], endpoint, args) if server[:name]
        end
      end

      private

      # Perform setup tasks in ApiCommuniction.send_to_one
      # Params:
      # +input+:: The server you want to connect to
      # +endpoint+:: The REST endpoint you'd like to send a request to
      # +args+:: Any specific configuration data to send along with the request
      def setup(input, endpoint, args = {})
        server_name = input
        remote_site = nil
        server_name, remote_site = input.split('/') if input.to_s.include?('/')

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
        endpoint.add(:query_string, Utils.to_query_string(args))

        [server, endpoint]
      end
    end
  end
end