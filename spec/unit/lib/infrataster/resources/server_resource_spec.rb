require 'unit/spec_helper'

module Infrataster
  module Resources
    describe ServerResource do
      context 'when invoked address' do
        it 'returns an address' do
          Server.define(:app, '127.0.0.1')
          i = described_class.new(:app)
          expect(i.address).to eq('127.0.0.1')
        end
      end
    end
  end
end
