require 'capybara'
require 'capybara/rspec/matchers'
require 'selenium-webdriver'

module Infrataster
  module Contexts
    class CapybaraContext < BaseContext
      def initialize(*args)
        super(*args)

        register_capybara_driver
      end

      def session
        return @session if @session

        address, port, @gateway_finalize_proc = server.from_gateway_open(resource.uri.port)
        Capybara.app_host = "http://#{address}:#{port}"
        @session = Capybara::Session.new(capybara_driver_name)
      end

      def page
        session
      end

      def before_each(example)
        example.example_group_instance.extend(Capybara::RSpecMatchers)
      end

      def after_each(example)
        @gateway_finalize_proc.call if @gateway_finalize_proc
      end

      def method_missing(method, *args)
        session.public_send(method, *args)
      end

      private
      def register_capybara_driver
        proxy = BrowsermobProxy.server.create_proxy
        proxy.header({"Host" => resource.uri.host})

        profile = Selenium::WebDriver::Firefox::Profile.new
        profile.proxy = proxy.selenium_proxy

        Capybara.register_driver capybara_driver_name do |app|
          Capybara::Selenium::Driver.new(app, profile: profile)
        end
      end

      def capybara_driver_name
        :"selenium_via_proxy_#{hash}"
      end
    end
  end
end
