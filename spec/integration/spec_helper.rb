require 'infrataster/rspec'

Infrataster::Server.define(
  :proxy,
  '192.168.0.0/16',
  vagrant: true,
)
Infrataster::Server.define(
  :app,
  '172.16.0.0/16',
  vagrant: true,
  from: :proxy,
  http: {host: 'example.com'},
)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

