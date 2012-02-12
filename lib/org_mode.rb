# Public: Domain objects
# describing the elements of an org-mod file
#
# OrgMode::File encapsulates the org file, with all its settings
# customizations, code blocks, TODO statusses.
#
# This domain model will be build using one of the parsers which
# you can find somewhere in lib/org_mode/parser*
#
# Writing this domain-model to a file can be done using
# one of the Writes in lib/org_mode/writers/*
#
require "org_mode/version"

module OrgMode

  class Node
    attr_accessor :title, :content, :stars, :date, :date_start_time, :date_end_time, :todo_state
    attr_accessor :parent, :children

    def initialize
      @parent = nil
      @children = []
    end

    def indent 
      stars + 1
    end 

    def root_node?
      stars == 1
    end

    def scheduled?
      !date.nil?
    end

    def appointment?
      !!( date_start_time || date_end_time )
    end

    def open?
      not done?
    end

    def done?
      todo_state == 'DONE'
    end

  end

  module FileInterface
    def root_nodes
      nodes.select(&:root_node?)
    end

    def scheduled_nodes
      nodes.select(&:scheduled?)
    end
  end

  class File
    attr_accessor :header, :root_nodes, :footer

    include FileInterface

    def initialize(header, root_nodes, footer)
      @header = header
      @footer = footer
      @root_nodes = root_nodes
    end

    def nodes
      serialize_nodes(root_nodes)
    end

    private

    # recusively serializes 
    # the nodes
    def serialize_nodes(nodes)
      nodes.map do |n|
       [n] + serialize_nodes(n.children) 
      end.flatten
    end
  end

  class FileCollection
    attr_accessor :files

    include FileInterface

    def initialize(files)
      @files = files 
    end

    def nodes
      files.map(&:nodes).flatten
    end
  end
end
