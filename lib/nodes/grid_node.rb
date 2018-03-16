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

      def name
        @configuration["capabilities"]["applicationName"]
      end

      def multi_caps?
        @configuration["capabilities"].is_a?(Array) ? true : false
      end

      def capabilities_by_attributes(*opts)
        multi_caps? ? find_cap(@configuration, opts.first) : has_attrs?(@configuration["capabilities"], opts.first)
      end

      def free?
        if down?
          @free = false
        else
          sessions = @data.sessions
          @free = sessions["value"].size == 0 ? true : false
        end
        @free
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

      private

      def find_cap(config, opts)
        result = nil
        config["capabilities"].each do |c|
          if result.nil? && has_attrs?(c, opts)
            result = c
          end
        end
        result
      end

      def has_attrs?(main, sub)
        result = []
        sub.each do |k,v|
          result << true if (main.has_key?(k.to_s) && main[k.to_s] == v)
        end
        (!result.any? || result.include?(false)) ? false : true
      end
    end
  end
end
