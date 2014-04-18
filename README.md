# Infrataster

Infrastructure Behavior Testing Framework.

## Usage

First, create `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'infrataster'
```

Install gems:

```
$ bundle install
```

Initialize rspec directory:

```
$ rspec --init
  create   spec/spec_helper.rb
  create   .rspec
```

`require infrataster/rspec` and define target servers for testing:

```ruby
# spec_helper.rb
require 'infrataster/rspec'

Infrataster::Server.define(
  :proxy,          # name
  '192.168.33.10', # ip address
  vagrant: true,   # for vagrant VM
)
Infrataster::Server.define(
  :app,            # name
  '172.16.33.11',  # ip address
  vagrant: true,   # for vagrant VM
  from: :proxy     # access to this machine via SSH port forwarding from proxy
)
Infrataster::Server.define(
  :db,             # name
  '172.16.33.12',  # ip address
  vagrant: true,   # for vagrant VM
  from: :app,      # access to this machine via SSH port forwarding from app
  mysql: {user: 'app', password: 'app'}
                   # settings for MySQL
)
```

If you use `capybara`, you should download and extract [BrowserMob Proxy](http://bmp.lightbody.net/) and set `Infrataster::BrowsermobProxy.bin_path` to binary path:

```
# spec_helper.rb
Infrataster::BrowsermobProxy.bin_path = '/path/to/browsermob/bin/browsermob'
```

Then, you can write spec files:

```ruby
require 'spec_helper'

describe server(:app) do
  describe http('http://app') do
    it "responds content including 'Hello Sinatra'" do
      expect(response.body).to include('Hello Sinatra')
    end
    it "responds as 'text/html'" do
      expect(response.header.content_type).to eq('text/html')
    end
  end
  describe capybara('http://app') do
    it "responds content including 'Hello Sinatra'" do
      visit '/'
      expect(page).to have_content('Hello Sinatra')
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
    it "responds content including 'Hello Sinatra'" do
      expect(response.body).to include('Hello Sinatra')
    end
  end
  describe http('http://static') do
    it "responds content including 'Welcome to nginx!'" do
      expect(response.body).to include('Welcome to nginx!')
    end
  end
  describe capybara('http://app') do
    it "responds content including 'Hello Sinatra'" do
      visit '/'
      expect(page).to have_content('Hello Sinatra')
    end
  end
  describe capybara('http://static') do
    it "responds content including 'Welcome to nginx!'" do
      visit '/'
      expect(page).to have_content('Welcome to nginx!')
    end
  end
end
```

## Example

[infrataster/example](example)

## Contributing

1. Fork it ( http://github.com/ryotarai/infrataster/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
