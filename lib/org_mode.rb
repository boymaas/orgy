require "org_mode/version"

module OrgMode

  class File
    attr_accessor :header, :nodes, :footer
    def initialize(header, nodes, footer)
      @header = header
      @footer = footer
      @nodes = nodes
    end

    def root_nodes
      @nodes.select(&:root_node?)
    end
  end

  class Node
    attr_accessor :title, :content, :stars, :indent, :date, :todo_state
    attr_accessor :parent, :children

    def initialize
      @parent = nil
      @children = []
    end

    def root_node?
      parent.nil?
    end
  end
end


