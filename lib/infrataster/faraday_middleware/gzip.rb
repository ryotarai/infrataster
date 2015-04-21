# This module is ported from faraday_middleware:
# https://github.com/lostisland/faraday_middleware/blob/138766e3d1cfd58b01d1c3ccb453bb8bc7c1633a/lib/faraday_middleware/gzip.rb
#
# Copyright (c) 2011 Erik Michaels-Ober, Wynn Netherland, et al.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'faraday'

module Infrataster
  module FaradayMiddleware
    # Middleware to automatically decompress response bodies. If the
    # "Accept-Encoding" header wasn't set in the request, this sets it to
    # "gzip,deflate" and appropriately handles the compressed response from the
    # server. This resembles what Ruby 1.9+ does internally in Net::HTTP#get.
    #
    # This middleware is NOT necessary when these adapters are used:
    # - net_http on Ruby 1.9+
    # - net_http_persistent on Ruby 2.0+
    # - em_http
    class Gzip < Faraday::Middleware
      dependency 'zlib'

      ACCEPT_ENCODING = 'Accept-Encoding'.freeze
      CONTENT_ENCODING = 'Content-Encoding'.freeze
      CONTENT_LENGTH = 'Content-Length'.freeze
      SUPPORTED_ENCODINGS = 'gzip,deflate'.freeze
      RUBY_ENCODING = '1.9'.respond_to?(:force_encoding)

      def call(env)
        env[:request_headers][ACCEPT_ENCODING] ||= SUPPORTED_ENCODINGS
        @app.call(env).on_complete do |response_env|
          case response_env[:response_headers][CONTENT_ENCODING]
          when 'gzip'
            reset_body(response_env, &method(:uncompress_gzip))
          when 'deflate'
            reset_body(response_env, &method(:inflate))
          end
        end
      end

      def reset_body(env)
        env[:body] = yield(env[:body])
        env[:response_headers].delete(CONTENT_ENCODING)
        env[:response_headers][CONTENT_LENGTH] = env[:body].length
      end

      def uncompress_gzip(body)
        io = StringIO.new(body)
        gzip_reader = if RUBY_ENCODING
          Zlib::GzipReader.new(io, :encoding => 'ASCII-8BIT')
        else
          Zlib::GzipReader.new(io)
        end
        gzip_reader.read
      end

      def inflate(body)
        Zlib::Inflate.inflate(body)
      end
    end
  end
end

