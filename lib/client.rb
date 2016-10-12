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
require "client/helper/time"
require "client/helper/results"
require "client/config"
require "client/request"
require "client/utils"
require "client/controller"
require "client/router"
require "client/helper/endpoint"
require "client/helper/formatting"
require "client/helper/apicommunication"
require "client/helper/network"
require "client/helper"

module Vermillion
  # Flag to determine if module is running in test mode
  def self.test?
    false
  end
end