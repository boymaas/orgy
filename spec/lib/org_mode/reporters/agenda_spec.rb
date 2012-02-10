require 'org_mode/reporters/agenda'
require 'support/blueprints'

describe OrgMode::Reporters::Agenda do
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

  it "reports the scheduled nodes correctly" do
  end

end
