require 'unit/spec_helper'

module Infrataster
  module Resources
    describe HttpResource do
      context "with no scheme URI" do
        it "complements scheme" do
          resource = HttpResource.new('/path/to/resource')
          expect(resource.uri.scheme).to eq('http')
        end
      end
    end
  end
end
