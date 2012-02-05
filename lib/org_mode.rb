require "org_mode/version"

module OrgMode

  class File
    attr_accessor :header, :nodes, :footer
    def initialize(header, nodes, footer)
      @header = header
      @footer = footer
      @nodes = nodes
    end
  end

  class Node
    attr_accessor :title, :content, :stars, :indent, :date, :todo_state
  end
end


