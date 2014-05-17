require 'integration/spec_helper'

describe server(:proxy) do
  describe tcp_port(80) do
    it 'is opened' do
      expect(opened?).to be_true
    end
  end

  describe tcp_port(123) do
    it 'is not opened' do
      expect(opened?).to be_false
    end
  end
end

describe server(:app) do
  describe tcp_port(80) do
    it 'is opened' do
      expect(opened?).to be_true
    end
  end

  describe tcp_port(123) do
    it 'is not opened' do
      expect(opened?).to be_false
    end
  end
end
