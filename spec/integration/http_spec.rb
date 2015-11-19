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

  describe http('http://static.example.com', headers: {"Accept-Encoding" => "gzip"}) do
    it "gets response compressed by gzip" do
      expect(response.headers['content-encoding']).to eq('gzip')
    end
  end

  describe http('http://static.example.com', headers: {"Accept-Encoding" => "gzip"}, inflate_gzip: true) do
    it "gets response inflated by gzip" do
      expect(response.headers['content-encoding']).to be_nil
      expect(response.body).to eq("This is static site.\n")
    end
  end

  describe http('http://static.example.com/auth') do
    it "sends GET request without basic auth" do
      expect(response.status).to eq 401
    end
  end

  describe http('http://static.example.com/auth', basic_auth: ['dummy', 'dummy']) do
    it "sends GET request with basic auth" do
      expect(response.status).to eq 200
      expect(response.body).to include('auth')
    end
  end

  describe http('http://static.example.com/redirect') do
    it "doesn't follow redirects" do
      expect(response.status).to eq 302
    end
  end

  describe http('http://static.example.com/redirect', follow_redirects: true) do
    it "follows redirects" do
      expect(response.status).to eq 200
      expect(response.body).to eq("This is static site.\n")
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

  describe http('http://app.example.com', method: :post, body: {'foo' => 'bar'}, headers: {'USER' => 'VALUE'}) do
    it "sends POST request with body entity" do
      expect(body_as_json['method']).to eq('POST')
      expect(body_as_json['body']).to eq("foo=bar")
      expect(body_as_json['headers']['USER']).not_to be_empty
      expect(body_as_json['headers']['USER']).to eq('VALUE')
    end
  end

  describe http('http://app.example.com', method: :post, body: {'foo' => 'bar'}.to_json, headers: {'USER' => 'VALUE'}) do
    it "sends POST request with body entity as JSON format" do
      expect(body_as_json['method']).to eq('POST')
      expect(body_as_json['body']).to eq({"foo" => "bar"}.to_json)
      expect(body_as_json['headers']['USER']).not_to be_empty
      expect(body_as_json['headers']['USER']).to eq('VALUE')
    end
  end

  describe http('/path/to/resource') do
    it "sends GET request with scheme and host" do
      expect(body_as_json['headers']['HOST']).to eq('example.com')
    end
  end
end

describe server(:example_com) do
  describe http('https://example.com') do
    it "is example domain" do
      expect(response.body).to include('Example Domain')
    end
  end
end
