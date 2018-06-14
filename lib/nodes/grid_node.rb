require_relative 'data/grid_node_data'

module SeleniumGridConsoleParser
  module Nodes
    class GridNode
      attr_reader :remoteHost, :configuration

      def initialize(configuration)
        @remoteHost = configuration["remoteHost"]
        @configuration = configuration.delete_if {|key, value| key == "remoteHost"}
        @down = false
        @data = GridNodeData.new(self)
      end

      def capabilities
        @configuration["capabilities"]
      end

      def custom
        @configuration["custom"].gsub(/[{}:]/,'').split(', ')
          .map{|h| h1,h2 = h.split('='); {h1 => h2.strip}}.reduce(:merge)
      end

      def status
        return 'free' if free?
        return 'busy' if busy?
        return 'down' if down?
        'unknown'
      end

      def free?
        busy? || down? ? false : true
      end

      def busy?
        sessions = @data.sessions
        sessions["value"].size == 0 ? false : true
      end

      def down?
        begin
          @data.sessions
        rescue NodeDownException
          @down = true
          return true
        end
        @down = false
        return false
      end

      def to_hash
        free?
        grid_node_hash = self.instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
        grid_node_hash.delete("data")
        grid_node_hash
      end
    end
  end
end
