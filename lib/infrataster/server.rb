require 'tmpdir'
require 'net/ssh'
require 'net/ssh/gateway'
require 'ipaddr'

module Infrataster
  class Server
    Error = Class.new(StandardError)

    class << self

      def define(*args)
        @@servers << Server.new(*args)
      end

      def defined_servers
        @@servers
      end

      def clear_defined_servers
        @@servers = []
      end

      def find_by_name(name)
        server = @@servers.find {|s| s.name == name }
        unless server
          raise Error, "Server definition for '#{name}' is not found."
        end
        server
      end

      Server.clear_defined_servers
    end

    attr_reader :name, :address, :options

    def initialize(name, address, options = {})
      @name, @address, @options = name, address, options
    end

    def from
      if @options[:from]
        Server.find_by_name(@options[:from])
      end
    end

    def ssh_gateway
      gateway = Net::SSH::Gateway.new(*ssh_start_args)
      finalize_proc = Proc.new do
        gateway.shutdown!
      end

      [gateway, finalize_proc]
    end

    def with_ssh_gateway
      gateway, finalize_proc = ssh_gateway
      yield gateway
    ensure
      finalize_proc.call
    end

    def gateway_open(*args)
      if block_given?
        with_ssh_gateway do |gateway|
          gateway.open(*args) do |port|
            yield port
          end
        end
      else
        gateway, gateway_finalize_proc = ssh_gateway
        port = gateway.open(*args)
        finalize_proc = Proc.new do
          gateway.close(port)
          gateway_finalize_proc.call
        end
        [port, finalize_proc]
      end
    end

    def from_gateway_open(port)
      if from
        new_port, finalize_proc = from.gateway_open(@address, port)
        Logger.debug("tunnel: localhost:#{new_port} -> #{from.address} -> #{@address}:#{port}")
        ['127.0.0.1', new_port, finalize_proc]
      else
        [@address, port, nil]
      end
    end

    def from_gateway(port)
      if from
        from.gateway_open(@address, port) do |new_port|
          Logger.debug("tunnel: localhost:#{new_port} -> #{from.address} -> #{@address}:#{port}")
          yield '127.0.0.1', new_port
        end
      else
        yield @address, port
      end
    end

    def ssh_start_args
      @ssh_start_args ||= _ssh_start_args
    end

    private


    def _ssh_start_args
      config = {}
      if @options[:ssh]
        config = @options[:ssh]
      elsif @options[:vagrant]
        if @options[:vagrant] != true
          vagrant_name = @options[:vagrant]
        else
          vagrant_name = @name
        end

        Dir.mktmpdir do |dir|
          output = File.join(dir, 'ssh-config')
          system("/usr/bin/vagrant ssh-config #{vagrant_name} > #{output}")
          config = Net::SSH::Config.for(@name.to_s, [output])
        end
      else
        raise Error, "Can't get configuration to connect to the server via SSH. Please set ssh option or vagrant option."
      end

      [config[:host], config[:user], config]
    end
  end
end

