require 'capybara'
require 'capybara/rspec/matchers'
require 'capybara/poltergeist'

module Infrataster
  module Contexts
    class CapybaraContext < BaseContext
      def self.session
        @session ||= prepare_session
      end

      def self.prepare_session
        capybara_driver_name = :infrataster_driver

        proxy = BrowsermobProxy.proxy
        Capybara.register_driver capybara_driver_name do |app|
          Capybara::Poltergeist::Driver.new(
            app,
            phantomjs_options: ["--proxy=http://#{proxy.host}:#{proxy.port}"],
          )
        end
        Capybara::Session.new(capybara_driver_name)
      end

      def initialize(*args)
        super(*args)
      end

      def session
        self.class.session
      end

      def page
        session
      end

      def before_each(example)
        example.example_group_instance.extend(Capybara::RSpecMatchers)

        proxy = BrowsermobProxy.proxy
        proxy.header({"Host" => resource.uri.host})

        address, port, @gateway_finalize_proc = server.from_gateway_open(resource.uri.port)
        Capybara.app_host = "http://#{address}:#{port}"
      end

      def after_each(example)
        @gateway_finalize_proc.call if @gateway_finalize_proc
      end

      def method_missing(method, *args)
        session.public_send(method, *args)
      end
    end
  end
end
