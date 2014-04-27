require 'sinatra'
require 'json'

get '/' do
  result = {
    'app' => 'sinatra',
    'method' => 'GET',
    'params' => params,
    'headers' => RequestWrapper.new(request).headers,
  }

  result.to_json
end

post '/' do
  result = {
    'app' => 'sinatra',
    'method' => 'POST',
    'params' => params,
    'headers' => RequestWrapper.new(request).headers,
  }

  result.to_json
end

class RequestWrapper
  def initialize(request)
    @request = request
  end

  def headers
    headers = @request.env.select do |k, v|
      k.start_with?('HTTP_')
    end.map do |k, v|
      [k[5..-1], v]
    end
    Hash[headers]
  end
end
