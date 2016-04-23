require 'unit/spec_helper'

module Infrataster
  module Resources
    describe ServerResource do
      context "when address invoked" do
        it "returns address" do
          app_server = Server.new('name', '127.0.0.2')
          expect(app_server.address).to eq('127.0.0.2')
        end
      end
    end
  end
end
