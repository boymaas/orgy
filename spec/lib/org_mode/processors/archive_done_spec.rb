require 'org_mode/processors/archive_done'
require 'support/blueprints'
require 'support/include_hash'
require 'timecop'

# When can we archive a tree
#
# we can archive a tree when all dones
# of a tree are done. Or the root-tree is done

describe OrgMode::Processors::ArchiveDone do

  let(:org_file) do
    nodes = []
    nodes << OrgMode::Node.make(:stars => 1, 
                                :todo_state => 'DONE', 
                                :date => Date.parse('2012-06-01'))
    nodes << OrgMode::Node.make(:stars => 2, :date=>Date.parse('2012-02-03'))
    nodes << OrgMode::Node.make(:stars => 3, :date=>DateTime.parse('2012-02-01 15:00'))
    OrgMode::File.make(:nodes => nodes)
  end

  context '#process' do
    let(:processed_org_file) do
      processor = OrgMode::Processors::ArchiveDone.new(org_file)
      processor.process
    end

    context 'archived_node' do
      let(:archived_nodes) do
        processed_org_file.select_by_title(/^Archived$/, :stars => 1)
      end

      it 'should have created a node "Archived"' do
        archived_nodes.length.should == 1
      end

      it 'should have added the DONE tree to the archived ones' do
        #archived_nodes[0].children.length.should == 1
      end
    end
  end

end
