require 'unit/spec_helper'

module Infrataster
  describe Server do
    describe "self.define" do
      it "adds a Server instance to defined_servers" do
        described_class.define('name', 'address', {})
        servers = described_class.defined_servers
        expect(servers.size).to eq(1)
        expect(servers[0].name).to eq('name')
        expect(servers[0].address).to eq('address')
        expect(servers[0].options).to eq({})
      end
    end

    describe "self.find_by_name" do
      it "finds a server by name" do
        described_class.define('name', 'address', {})
        server = described_class.find_by_name('name')
        expect(server.name).to eq('name')
        expect(server.address).to eq('address')
        expect(server.options).to eq({})
      end
    end

    describe "#from" do
      it "returns 'from' server instance" do
        described_class.define('proxy', 'address', {})
        described_class.define('app', 'address', from: 'proxy')
        app_server = described_class.find_by_name('app')
        expect(app_server.from.name).to eq('proxy')
      end
    end

    describe "#ssh_gateway" do
      it "returns gateway instance and proc for finalizing" do
        server = Server.new('name', 'address', ssh: {host_name: 'host', user: 'user'})

        gateway_mock = double
        expect(gateway_mock).to receive(:shutdown!)
        expect(Net::SSH::Gateway).to receive(:new).and_return(gateway_mock)
        gateway, finalize_proc = server.ssh_gateway
        finalize_proc.call
        expect(gateway).to eq(gateway_mock)
      end
    end

    describe "#_ssh_start_args" do
      context "with ssh option" do
        context "when options[:ssh][:host] is set" do
          it 'returns args for SSH.start' do
            server = Server.new('name', 'address', ssh: {host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end

        context "when options[:ssh][:host] is not set" do
          it 'returns args for SSH.start' do
            server = Server.new('name', 'address', ssh: {user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['address', 'user', {host_name: 'address', user: 'user'}])
          end
        end
      end
      
      context "with vagrant option" do
        context "when vagrant option is true" do
          it 'returns args for SSH.start' do
            server = Server.new('name', 'address', vagrant: true)
            expect(server).to receive(:ssh_config_for_vagrant).with('name').
              and_return({host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end

        context "when vagrant option is not true but truthy" do
          it 'returns args for SSH.start' do
            server = Server.new('name', 'address', vagrant: 'vagrant_vm_name')
            expect(server).to receive(:ssh_config_for_vagrant).with('vagrant_vm_name').
              and_return({host_name: 'host', user: 'user'})
            expect(server.send(:_ssh_start_args)).
              to eq(['host', 'user', {host_name: 'host', user: 'user'}])
          end
        end
      end

      context "otherwise" do
        it 'raises an error' do
          server = Server.new('name', 'address')
          expect do
            server.send(:_ssh_start_args)
          end.to raise_error(Server::Error)
        end
      end
    end
  end
end

