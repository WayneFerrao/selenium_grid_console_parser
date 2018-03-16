require_relative '../client/grid_node_client'

require 'json'

module SeleniumGridConsoleParser
  module Nodes
    class GridNodeData
      def initialize(node)
        @node = node
        @cache = GridNodeCacheData.new()
      end

      def sessions
        if (@cache.valid? && @cache.read("sessions"))
          sessions = @cache.read("sessions")
        else
          sessions = GridNodeClient.new(@node.remoteHost).sessions
          @cache.write("sessions", sessions)
        end
        JSON.parse(sessions)
      end
    end

    class GridNodeCacheData
      def initialize(cache_duration_in_secs = 20)
        @max_seconds = cache_duration_in_secs
        @data = {}
        @time = 0
      end

      def valid?
        time_difference = (Time.now - @time).to_i
        if time_difference > @max_seconds
          @data = {}
          return false
        else
          return true
        end
      end

      def write(key,value)
        @data[key] = value
        @time = Time.now
      end

      def read(key)
        @data[key]
      end
    end
  end
end
