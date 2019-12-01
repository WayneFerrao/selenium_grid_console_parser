require 'nokogiri'
require 'net/http'

require_relative 'nodes/grid_node'
require_relative 'nodes/grid_node_set'
require_relative 'nodes/configuration/node_configuration'

module SeleniumGridConsoleParser
  class << self
    def nodes(url)
      Parser.new(url).nodes
    end
  end
  class Parser

    def initialize(url)
      url = "#{url}/grid/console"
      @page = Nokogiri::HTML(Net::HTTP.get(URI(url)))
    end

    def nodes
      extract_node(@page.css("div[class='proxy']"))
    end

    private

    def extract_node(nodes_elements)
      nodes = SeleniumGridConsoleParser::Nodes::GridNodeSet.new()
      nodes_elements.each do |node_elements|
        configuration_elements = node_elements.css("[type='config'] > p")
        configuration = SeleniumGridConsoleParser::GridNode::GridNodeConfiguration.build(configuration_elements)
        nodes.add (SeleniumGridConsoleParser::Nodes::GridNode.new(configuration))
      end
      nodes
    end
  end
end
