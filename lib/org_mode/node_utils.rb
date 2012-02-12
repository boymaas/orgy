module OrgMode
  class NodeUtils
    # Public: transforms a sequental list of 
    # nodes into a tree structure setting
    # parents and children on the nodes
    def self.convert_sequential_nodelist_into_tree(nodes)
      parent_stack = []
      nodes.map! do |node| 
        node.parent = parent_stack[node.stars - 1]
        if node.parent
          node.parent.children << node
        end
        parent_stack[node.stars] = node
      end

      # filter out all non root nodes
      nodes.select(&:root_node?)
    end
  end
end
