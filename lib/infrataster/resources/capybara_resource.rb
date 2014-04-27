require 'infrataster/resources/base_resource'
require 'uri'

module Infrataster
  module Resources
    class CapybaraResource < BaseResource
      Error = Class.new(StandardError)

      attr_reader :uri

      def initialize(url)
        @uri = URI.parse(url)
      end

      def to_s
        "capybara '#{@uri}'"
      end
    end
  end
end

