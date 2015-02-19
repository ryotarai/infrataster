require 'infrataster'
require 'rspec'

include Infrataster::Helpers::ResourceHelper

RSpec.configure do |config|
  config.include Infrataster::Helpers::RSpecHelper

  fetch_current_example = RSpec.respond_to?(:current_example) ?
                            proc { RSpec.current_example }
                          : proc { |context| context.example }

  config.before(:all) do
    @infrataster_context = Infrataster::Contexts.from_example(self.class)
  end

  config.before(:each) do
    current_example = fetch_current_example.call(self)
    @infrataster_context = Infrataster::Contexts.from_example(current_example)
    @infrataster_context.before_each(current_example) if @infrataster_context.respond_to?(:before_each)
  end

  config.after(:each) do
    current_example = fetch_current_example.call(self)
    @infrataster_context.after_each(current_example) if @infrataster_context.respond_to?(:after_each)
  end

  config.after(:all) do
    Infrataster::Server.defined_servers.each do |server|
      server.shutdown_gateway
    end
  end
end
