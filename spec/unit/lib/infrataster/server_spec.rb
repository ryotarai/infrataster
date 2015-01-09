require 'unit/spec_helper'

module Infrataster
  describe Server do
    describe "self.define" do
      it "adds a Server instance to defined_servers" do
        described_class.define('name', '127.0.0.1', {})
        servers = described_class.defined_servers
        expect(servers.size).to eq(1)
        expect(servers[0].name).to eq('name')
        expect(servers[0].address).to eq('127.0.0.1')
        expect(servers[0].options).to eq({})
      end
      it "adds a Server instance to defined_servers with block" do
        described_class.define(:app) do |server|
          server.address = '127.0.0.1'
          server.vagrant = true
          server.from = :proxy
        end
        described_class.define(:proxy) do |server|
          server.address = '127.0.0.1'
          server.vagrant = true
        end
        servers = described_class.defined_servers
        expect(servers.size).to eq(2)
        expect(servers[0].name).to eq(:app)
        expect(servers[0].address).to eq('127.0.0.1')
        expect(servers[0].options[:vagrant]).to eq(true)
        expect(servers[0].from).to eq(servers[1])
      end
    end

    describe "self.find_by_name" do
      it "finds a server by name" do
        described_class.define('name', '127.0.0.1', {})
        server = described_class.find_by_name('name')
        expect(server.name).to eq('name')
        expect(server.address).to eq('127.0.0.1')
        expect(server.options).to eq({})
      end
    end

    describe "#from" do
      it "returns 'from' server instance" do
        described_class.define('proxy', '127.0.0.1', {})
        described_class.define('app', '127.0.0.1', from: 'proxy')
        app_server = described_class.find_by_name('app')
        expect(app_server.from.name).to eq('proxy')
      end
    end

    describe "#_ssh_start_args" do
      context "with ssh option" do
        context "when options[:ssh][:host] is set" do
          it 'returns args for SSH.start' do
            server = Server.new('name', '127.0.0.1', ssh: {host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end

        context "when options[:ssh][:host] is not set" do
          it 'returns args for SSH.start' do
            server = Server.new('name', '127.0.0.1', ssh: {user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['127.0.0.1', 'user', {host_name: '127.0.0.1', user: 'user'}])
          end
        end
      end
      
      context "with vagrant option" do
        context "when vagrant option is true" do
          it 'returns args for SSH.start' do
            server = Server.new('name', '127.0.0.1', vagrant: true)
            expect(server).to receive(:ssh_config_for_vagrant).with('name').
              and_return({host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end

        context "when vagrant option is not true but truthy" do
          it 'returns args for SSH.start' do
            server = Server.new('name', '127.0.0.1', vagrant: 'vagrant_vm_name')
            expect(server).to receive(:ssh_config_for_vagrant).with('vagrant_vm_name').
              and_return({host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end
      end

      context "otherwise" do
        it 'raises an error' do
          server = Server.new('name', '127.0.0.1')
          expect do
            server.send(:_ssh_start_args)
          end.to raise_error(Server::Error)
        end
      end
    end
  end
end

