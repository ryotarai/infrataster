require 'tmpdir'
require 'net/ssh'
require 'net/ssh/gateway'
require 'ipaddr'
require 'shellwords'

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

    def find_available_port
      # find available local port
      server = TCPServer.new('127.0.0.1', 0)
      available_port = server.addr[1]
      server.close

      available_port
    end

    def gateway
      @gateway ||= Net::SSH::Gateway.new(*ssh_start_args)
    end

    def shutdown_gateway
      if @gateway
        @gateway.shutdown!
        @gateway = nil
      end
    end

    def forward_port(port, &block)
      host, forwarded_port = _forward_port(port)
      if block_given?
        return_value = block.call(host, forwarded_port)
        from.gateway.close(forwarded_port) if from
        return_value
      else
        [host, forwarded_port]
      end
    end

    def ssh_exec(cmd, &block)
      result = nil
      Net::SSH.start(*ssh_start_args) do |ssh|
        result = ssh.exec!(cmd, &block)
      end
      result
    end

    def ssh_start_args
      @ssh_start_args ||= _ssh_start_args
    end

    private

    def _forward_port(port)
      if from
        local_port = from.gateway.open(@address, port, find_available_port)
        ['127.0.0.1', local_port]
      else
        # no need to forward port
        [@address, port]
      end
    end

    def _ssh_start_args
      config = {}

      if @options[:ssh]
        config = @options[:ssh]
        config[:host_name] ||= @address
      elsif @options[:vagrant]
        vagrant_name = if @options[:vagrant] != true
                         @options[:vagrant]
                       else
                         @name
                       end
        config = ssh_config_for_vagrant(vagrant_name)
      else
        raise Error, "Can't get configuration to connect to the server via SSH. Please set ssh option or vagrant option."
      end

      [config[:host_name], config[:user], config]
    end

    def ssh_config_for_vagrant(name)
      config = nil

      Dir.mktmpdir do |dir|
        output = File.join(dir, 'ssh-config')
        `/usr/bin/vagrant ssh-config #{Shellwords.shellescape(name)} > #{Shellwords.shellescape(output)}`
        if $?.exitstatus != 0
          raise Error, "`vagrant ssh-config` failed. Please check if VMs are running or not."
        end
        config = Net::SSH::Config.for(@name.to_s, [output])
      end

      config
    end
  end
end

