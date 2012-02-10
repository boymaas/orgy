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

    def scheduled_nodes
      @nodes.select(&:scheduled?)
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

    def scheduled?
      !date.nil?
    end

    def done?
      todo_state == 'DONE'
    end
  end
end
