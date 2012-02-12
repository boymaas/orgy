require 'org_mode'
require 'core_ext/string'
require 'delegate'

module OrgMode
  module Processors
    class ArchiveEnhancedOrgFile < SimpleDelegator
      def initialize(org_file)
        super(org_file)
      end

      def archived_root_node
        select_by_title(/^Archived$/, :stars => 1).first
      end

      def create_archived_root_node
        self.nodes << OrgMode::Node.new.tap do |n|
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
        @org_file = ArchiveEnhancedOrgFile.new(org_file)
      end

      def process
        @org_file.create_archived_root_node unless @org_file.archived_root_node
        @org_file
      end
    end
  end
end
