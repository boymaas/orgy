require 'org_mode'
require 'support/blueprints'

describe OrgMode::File do
  let(:file) do
    nodes = []
    files = []
    nodes << OrgMode::Node.make(:stars => 1)
    nodes << OrgMode::Node.make(:stars => 2, :date=>Time.now)
    nodes << OrgMode::Node.make(:stars => 3)
    nodes << OrgMode::Node.make(:stars => 1)
    OrgMode::File.make(:nodes => nodes)
  end

  it "accumulates correctly" do
    file.nodes.length.should == 4
  end

  it "detects all rootnodes correctly" do
    file.root_nodes.length.should == 2
  end

  it "detects all scheduled nodes correctly" do
    file.scheduled_nodes.length.should == 1
  end
end

describe OrgMode::FileCollection do
  let(:file_collection) do
    nodes = []
    files = []
    nodes << OrgMode::Node.make(:stars => 1)
    nodes << OrgMode::Node.make(:stars => 2)
    files << OrgMode::File.make(:nodes => nodes)
    nodes = []
    nodes << OrgMode::Node.make(:stars => 1)
    nodes << OrgMode::Node.make(:stars => 2, :date=>Time.now)
    nodes << OrgMode::Node.make(:stars => 3)
    files << OrgMode::File.make(:nodes => nodes)
    OrgMode::FileCollection.make(:files => files)
  end
  it "accumulates correctly" do
    file_collection.nodes.length.should == 5
  end

  it "detects all rootnodes correctly" do
    file_collection.root_nodes.length.should == 2
  end
  it "detects all scheduled nodes correctly" do
    file_collection.scheduled_nodes.length.should == 1
  end
end
