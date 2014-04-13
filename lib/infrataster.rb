require "infrataster/version"
require "infrataster/types"
require "infrataster/server"
require "infrataster/helpers"
require "infrataster/browsermob_proxy"
require "infrataster/contexts"
require 'logger'

module Infrataster
  Logger = ::Logger.new($stdout)
  Logger.level = ::Logger::ERROR
end
