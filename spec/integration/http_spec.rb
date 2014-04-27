require 'integration/spec_helper'

describe server(:proxy) do
  describe http('http://app.example.com') do
    it "responds with body including 'app'" do
      expect(response.body).to include('app')
    end
  end

  describe http('http://static.example.com') do
    it "responds with body including 'static'" do
      expect(response.body).to include('static')
    end
  end
end

describe server(:app) do
  describe http('http://app.example.com') do
    it "responds with body including 'app'" do
      expect(response.body).to include('app')
    end
  end
end


