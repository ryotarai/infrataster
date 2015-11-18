require 'tmpdir'
require 'net/ssh'
require 'net/ssh/gateway'
require 'ipaddr'
require 'shellwords'
require 'ostruct'

module Infrataster
  class Server
    Error = Class.new(StandardError)

    class << self

      def define(name, *args, &block)
        address = args.shift
        options = args.any? ? args.shift : {}
        if block
          st = OpenStruct.new
          block.call(st)
          address = st.address if st.address
          st.each_pair { |k, v| options[k] = v unless k == :address }
        end
        @@servers << Server.new(name, address, options)
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
      @name, @options = name, options
      @address = determine_address(address)
      @gateway = nil
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

    def ssh(&block)
      Net::SSH.start(*ssh_start_args) do |ssh|
        block.call(ssh)
      end
    end

    def ssh_exec(cmd, &block)
      result = nil
      ssh do |ssh|
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
        `vagrant ssh-config #{Shellwords.shellescape(name)} > #{Shellwords.shellescape(output)}`
        if $?.exitstatus != 0
          raise Error, "`vagrant ssh-config` failed. Please check if VMs are running or not."
        end
        config = Net::SSH::Config.for(@name.to_s, [output])
      end

      config
    end

    def fetch_all_addresses
      result = []
      ssh_exec('PATH="/sbin:$PATH" ip addr').each_line do |line|
        #inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
        if %r{inet ([^/]+)} =~ line
          result << $1
        end
      end

      result
    end

    def determine_address(address)
      begin
        ipaddr = IPAddr.new(address)
      rescue IPAddr::InvalidAddressError
        return address
      end

      Logger.debug("Determining ip address...")

      if ipaddr.to_range.begin == ipaddr.to_range.end
        # subnet mask is 255.255.255.255
        return ipaddr.to_s
      end

      all_addresses = fetch_all_addresses
      Logger.debug(all_addresses)

      matched = all_addresses.select do |a|
        ipaddr.include?(a)
      end
      Logger.debug(matched)

      if matched.empty?
        raise Error, "No IP address matching #{ipaddr} is not found."
      elsif matched.size > 1
        raise Error, "Multiple IP addresses matching #{ipaddr} are found."
      end

      matched.first
    end
  end
end
