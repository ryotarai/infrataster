require 'sinatra'
require 'json'

get '/' do
  result.to_json
end

get '/path/to/resource' do
  result.to_json
end

post '/' do
  result.to_json
end

def result
  {
    'app' => 'sinatra',
    'method' => request.request_method,
    'path' => request.path_info,
    'params' => params,
    'body' => request.body.read,
    'headers' => RequestWrapper.new(request).headers,
  }
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
