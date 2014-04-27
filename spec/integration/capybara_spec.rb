require 'integration/spec_helper'

describe server(:proxy) do
  describe capybara('http://app.example.com') do
    it 'has content "app"' do
      visit '/'
      expect(page).to have_content('app')
    end
  end
  describe capybara('http://static.example.com') do
    it 'has content "static"' do
      visit '/'
      expect(page).to have_content('static')
    end
  end
end

describe server(:app) do
  describe capybara('http://app.example.com') do
    it 'has content "app"' do
      visit '/'
      expect(page).to have_content('app')
    end
  end
end

