require 'integration/spec_helper'
require 'json'

describe server(:proxy) do
  describe http('http://app.example.com') do
    it "sends GET request with Host header" do
      expect(response.body).to include('app')
    end
  end

  describe http('http://static.example.com') do
    it "sends GET request with Host header" do
      expect(response.body).to include('static')
    end
  end
end

describe server(:app) do
  let(:body_as_json) { JSON.parse(response.body) }

  describe http('http://app.example.com') do
    it "sends GET request" do
      expect(response.body).to include('app')
    end
  end

  describe http('http://app.example.com/path/to/resource', params: {'foo' => 'bar'}, headers: {'USER' => 'VALUE'}) do
    it "sends GET request with params" do
      expect(body_as_json['method']).to eq('GET')
      expect(body_as_json['path']).to eq('/path/to/resource')
      expect(body_as_json['params']).to eq({"foo" => "bar"})
      expect(body_as_json['headers']['USER']).not_to be_empty
      expect(body_as_json['headers']['USER']).to eq('VALUE')
    end
  end

  describe http('http://app.example.com', method: :post, params: {'foo' => 'bar'}, headers: {'USER' => 'VALUE'}) do
    it "sends POST request with params" do
      expect(body_as_json['method']).to eq('POST')
      expect(body_as_json['params']).to eq({"foo" => "bar"})
      expect(body_as_json['headers']['USER']).not_to be_empty
      expect(body_as_json['headers']['USER']).to eq('VALUE')
    end
  end
end


