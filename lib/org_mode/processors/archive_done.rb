require 'org_mode'
require 'core_ext/string'
require 'delegate'

module OrgMode
  module Processors
    class ArchiveDoneOrgFile < SimpleDelegator
      def initialize(org_file)
        super(org_file)
      end

      def archived_root_node
        select_by_title(/^Archived$/, :stars => 1).first
      end

      def create_archived_root_node
        self.root_nodes << OrgMode::Node.new.tap do |n|
          n.title = "Archived"
          n.content = <<-eos.strip_indent(10)
          This node contains archived items. Appended
          due to calling the script with update --archive-done
          eos
          n.stars = 1
        end
      end

      def move_done_trees_to_archived_root_node
        processed_nodes = []
        self.nodes.each do |n|
          # if not done move to processed nodes
          # if done append to archived_root_node
        end
      end
    end

    class ArchiveDone
      def initialize(org_file)
        @org_file = ArchiveDoneOrgFile.new(org_file)
      end

      def process
        @org_file.create_archived_root_node unless @org_file.archived_root_node

        to_be_archived_trees = []
        walk_and_update_node_children @org_file do |children|
          to_be_archived_trees << children.select(&:done?)
          children.reject(&:done?)
        end

        @org_file.archived_root_node.children.concat(  to_be_archived_trees.flatten )

        @org_file
      end

      # Private: walks all nodes
      # but updates children array with
      # return value of called function.
      #
      # Can be used to extract nodes from
      # tree
      def walk_and_update_node_children(node, &block)
        node.children = block.call(node.children)
        node.children.map do |n|
          walk_and_update_node_children(n, &block) 
        end
      end
    end
  end
end
