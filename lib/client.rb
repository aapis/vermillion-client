# include external packages
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
require "mime/types"
require "yaml"

# include required files
require "client/version"
require "client/helpers/time"
require "client/helpers/results"
require "client/config"
require "client/request"
require "client/utils"
require "client/controller"
require "client/router"
require "client/endpoint"
require "client/helpers/formatting"
require "client/helpers/apicommunication"
require "client/helpers/network"
require "client/helper"

module Vermillion
  PACKAGE_NAME = 'vermillion-client'.freeze

  #
  # @since 0.3.0
  def self.test?
    false
  end
end