module Vermillion
  module Controller
    class Firstrun < Controller::Base

      def default
        if File.exist?(Dir.home + '/.vermillion.yml')
          Notify.error("Configuration already exists, this is not the first run!  Exiting.", show_time: false)
        end

        File.open(Dir.home + '/.vermillion.yml', "w") do |f|
          f.write <<-'CONTENTS'
servers:
  -
    name: dev
    address: 192.168.0.74
    https: false
    key: EDIT_ME
  -
    name: local
    address: localhost:8000
    https: false
    key: EDIT_ME
          CONTENTS
        end
      end

    end
  end
end
