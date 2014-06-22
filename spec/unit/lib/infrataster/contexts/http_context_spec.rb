require 'unit/spec_helper'

module Infrataster
  module Contexts
    describe HttpContext do
      context "with relative URI resource" do
        let(:address)  { '127.0.0.1' }
        let(:port)     { 80 }
        let(:resource) { Resources::HttpResource.new('/path/to/resource') }
        subject        { described_class.new(server, resource) }

        context "with http host definition" do
          let(:server) { Server.new('example.com', address, http: {:host => 'example.com'}) }

          it "complements host with server definition" do
            expect(subject.determine_host(address)).to eq('example.com')
          end
        end

        context "with no http host definition" do
          let(:server) { Server.new('example.com', address) }

          it "complements host with ip address" do
            expect(subject.determine_host(address)).to eq('127.0.0.1')
          end
        end
      end
    end
  end
end
