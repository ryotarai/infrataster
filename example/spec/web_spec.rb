require 'spec_helper'

describe server(:app) do
  describe http('http://app') do
    it "responds content including 'This is app server'" do
      expect(response.body).to include('This is app server')
    end
    it "responds as 'text/html'" do
      expect(response.content_type).to eq('text/html')
    end
    it "responds OK 200" do
      expect(response.code).to eq('200')
    end
  end
  describe capybara('http://app') do
    it "responds content including 'This is app server'" do
      visit '/'
      expect(page).to have_content('This is app server')
    end
  end
end

describe server(:db) do
  describe mysql_query('SHOW STATUS') do
    it 'responds uptime' do
      row = results.find {|r| r['Variable_name'] == 'Uptime' }
      expect(row['Value'].to_i).to be > 0
    end
  end
end

describe server(:proxy) do
  describe http('http://app') do
    it "responds content including 'This is app server'" do
      expect(response.body).to include('This is app server')
    end
    it "responds as 'text/html'" do
      expect(response.content_type).to eq('text/html')
    end
  end
  describe http('http://static') do
    it "responds content including 'Welcome to nginx!'" do
      expect(response.body).to include('Welcome to nginx!')
    end
    it "responds as 'text/html'" do
      expect(response.content_type).to eq('text/html')
    end
  end
  describe capybara('http://app') do
    it "responds content including 'This is app server'" do
      visit '/'
      expect(page).to have_content('This is app server')
    end
  end
  describe capybara('http://static') do
    it "responds content including 'Welcome to nginx!'" do
      visit '/'
      expect(page).to have_content('Welcome to nginx!')
    end
  end
end



