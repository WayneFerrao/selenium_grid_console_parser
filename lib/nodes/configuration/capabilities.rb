module SeleniumGridConsoleParser
  module GridNode
    class Capabilities < Hash
      def self.build (capabilities_from_console)
        capabilities_hash = {}
        capabilities_string = capabilities_from_console.match("{(.*)}")[1].split(", ")
        capabilities_string.each do |capability|
          capability_key_value = capability.split(":")
          capabilities_hash[capability_key_value[0]] = capability_key_value[1]
        end
        Capabilities[capabilities_hash]
      end
    end
  end
end
