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
Infrataster::Server.define(
  :example_com,
  'example.com',
)

RSpec.configure do |config|
  config.order = 'random'
end
