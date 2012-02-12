require 'org_mode'
require 'org_mode/node_utils'

class OrgMode::Node
  def self.make(attrs={})
    self.new.tap do |n|
      n.title = attrs[:title] || "org-node"
      n.stars = attrs[:stars] || rand(4)
      n.content = attrs[:content] || "org-node content"
      n.date = attrs[:date]
      n.date_start_time = attrs[:date_start_time]
      n.date_end_time = attrs[:date_end_time]
      n.todo_state = attrs[:todo_state] || 'TODO'
    end
  end
end

class OrgMode::File
  def self.make(attrs={})
    nodes = attrs[:nodes] || Array.new(2) { OrgMode::Node.make }
    root_nodes = OrgMode::NodeUtils.convert_sequential_nodelist_into_tree(nodes)
    self.new("aheader", root_nodes , "afooter")
  end
end

class OrgMode::FileCollection
  def self.make(attrs={})
    files = attrs[:files] || Array.new(2) { OrgMode::File.make }
    self.new( files ) 
  end
end
