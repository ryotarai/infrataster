require 'integration/spec_helper'

describe 'Normal subject not related to Infrataster' do
  it "doesn't raise any error" do
    expect(subject).not_to raise_error
  end
end

