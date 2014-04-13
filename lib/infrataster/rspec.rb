require 'infrataster'
require 'rspec'

include Infrataster::Helpers::TypeHelper

RSpec.configure do |config|
  config.include Infrataster::Helpers::RSpecHelper

  config.before(:each) do
    @infrataster_context = Infrataster::Contexts.from_example(example)
    @infrataster_context.before_each(example) if @infrataster_context.respond_to?(:before_each)
  end
  config.after(:each) do
    @infrataster_context.after_each(example) if @infrataster_context.respond_to?(:after_each)
  end
end

