require 'integration/spec_helper'

describe 'Normal subject not related to Infrataster' do
  it "doesn't raise any error" do
    expect(subject).not_to raise_error
  end
end

describe server(:proxy) do
  let(:time) { Time.now }
  before do
    current_server.ssh_exec "echo 'Hello' > /tmp/test-#{time.to_i}"
  end
  it "executes a command on the current server" do
    result = current_server.ssh_exec("cat /tmp/test-#{time.to_i}")
    expect(result.chomp).to eq('Hello')
  end
end

