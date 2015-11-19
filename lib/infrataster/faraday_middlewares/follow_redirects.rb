require 'faraday_middleware'

module Infrataster
  module FaradayMiddlewares
    class FollowRedirects < ::FaradayMiddleware::FollowRedirects
      def update_env(env, request_body, response)
        super.tap do |e|
          if replacement = @options[:host_mapping][e[:url].hostname]
            e[:request_headers]['Host'] = e[:url].hostname
            e[:url].hostname = replacement
          end
        end
      end
    end
  end
end
