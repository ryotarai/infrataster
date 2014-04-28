require 'infrataster/rspec'

Infrataster::Server.define(
  :proxy,
  '192.168.44.10',
  vagrant: true,
)
Infrataster::Server.define(
  :app,
  '172.16.44.11',
  vagrant: true,
  from: :proxy,
  mysql: {user: 'app', password: 'app'},
)

Infrataster::BrowsermobProxy.bin_path = File.expand_path('../vm/vendor/browsermob/bin/browsermob-proxy', __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

