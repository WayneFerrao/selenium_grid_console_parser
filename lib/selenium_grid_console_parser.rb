require 'nokogiri'
require 'open-uri'

require 'nodes/grid_node'
require 'nodes/grid_node_set'
require 'nodes/configuration/node_configuration'

module SeleniumGridConsoleParser
  class Parser

    def initialize(url)
      @page = Nokogiri::HTML(open("#{url}/grid/console"))
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