require 'mysql2'

module Infrataster
  module Contexts
    class MysqlQueryContext < BaseContext
      def results
        options = {port: 3306, user: 'root', password: ''}
        if server.options[:mysql]
          options = options.merge(server.options[:mysql])
        end

        server.gateway_on_from_server(options[:port]) do |address, new_port|
          client = Mysql2::Client.new(
            host: address,
            port: new_port,
            username: options[:user],
            password: options[:password],
          )
          client.query(resource.query)
        end
      end
    end
  end
end


