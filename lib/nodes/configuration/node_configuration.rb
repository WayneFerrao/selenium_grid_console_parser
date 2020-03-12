require_relative 'capabilities'

module SeleniumGridConsoleParser
  module GridNode
    class GridNodeConfiguration < Hash
      def self.build(configuration_html_elements)
        configuration = {}
        configuration["capabilities"] = []
        configuration_html_elements.each do |parameter_html_element|
          parameter = parameter_html_element.text.split(/: (.+)/)
          if parameter [0] == "custom"
            configuration["custom"] = set_custom_value(parameter[1])
          elsif parameter[0] != "capabilities"
            configuration[parameter[0]] = parameter[1]
          else
            configuration["capabilities"] << Capabilities.build(parameter[1])
          end
        end

        if configuration["capabilities"].count < 2
          configuration["capabilities"] = package_caps(configuration["capabilities"])
        end

        GridNodeConfiguration[configuration]
      end

      private

      def self.set_custom_value(val)
        val.gsub(/[{}:]/,'').split(', ')
           .map{|h| h1,h2 = h.split('=') ; {h1 => h2.nil? ? '' : h2.strip}}
           .reduce(:merge)
      end

      def self.package_caps(caps)
        caps.count == 1 ? caps.first : {}
      end
    end
  end
end
