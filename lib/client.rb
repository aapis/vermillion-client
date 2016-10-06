require "date"
require "time"
require "json"
require "optparse"
require "rbconfig"
require "net/http"
require "uri"
require "fileutils"
require "cgi"
require "notifaction"
require 'digest/md5'
require 'mime/types'
require 'yaml'

# include required files
require "client/kernel.rb"
require "client/version.rb"
require "client/helpers/time.rb"
require "client/helpers/results.rb"
require "client/log.rb"
require "client/config.rb"
require "client/request.rb"
require "client/utils.rb"
require "client/logs.rb"
require "client/command.rb"
require "client/controller.rb"
require "client/router.rb"
require "client/helpers/formatting.rb"
require "client/helpers/apicommunication.rb"
require "client/helpers/network.rb"
require "client/helper.rb"

module Vermillion
  #
  # @since 0.3.0
  def self.is_test?
    false
  end
end