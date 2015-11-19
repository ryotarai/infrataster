require "infrataster/version"
require "infrataster/resources"
require "infrataster/server"
require "infrataster/helpers"
require "infrataster/contexts"
require "infrataster/faraday_middlewares"
require 'logger'

module Infrataster
  Logger = ::Logger.new($stdout)
  if ENV['INFRATASTER_LOG']
    Logger.level = ::Logger.const_get(ENV['INFRATASTER_LOG'].upcase)
  else
    Logger.level = ::Logger::ERROR
  end
end
