require 'infrataster'
require 'rspec'

include Infrataster::Helpers::ResourceHelper

RSpec.configure do |config|
  config.include Infrataster::Helpers::RSpecHelper

  config.before(:each) do
    @infrataster_context = Infrataster::Contexts.from_example(example)
    @infrataster_context.before_each(example) if @infrataster_context.respond_to?(:before_each)
  end
  config.after(:each) do
    @infrataster_context.after_each(example) if @infrataster_context.respond_to?(:after_each)
  end

  config.after(:all) do
    Infrataster::Server.defined_servers.each do |server|
      server.shutdown_gateway
    end
  end
end

