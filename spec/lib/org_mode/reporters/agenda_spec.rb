require 'org_mode/reporters/agenda'
require 'support/blueprints'
require 'support/include_hash'
require 'timecop'

describe OrgMode::Reporters::Agenda do
  before do
    Timecop.freeze('2012-02-02')
  end
  let(:file_collection) do
    nodes = []
    files = []
    nodes << OrgMode::Node.make(:stars => 1, :date=>Date.parse('2012-02-01'))
    nodes << OrgMode::Node.make(:stars => 2, :date=>Date.parse('2012-02-05'))
    files << OrgMode::File.make(:nodes => nodes)
    nodes = []
    nodes << OrgMode::Node.make(:stars => 1, 
                                :todo_state => 'DONE', 
                                :date => Date.parse('2012-06-01'))
    nodes << OrgMode::Node.make(:stars => 2, :date=>Date.parse('2012-02-03'))
    nodes << OrgMode::Node.make(:stars => 3, :date=>Date.parse('2012-02-01'))
    files << OrgMode::File.make(:nodes => nodes)
    OrgMode::FileCollection.make(:files => files)
  end
  let(:reporter) { OrgMode::Reporters::Agenda.new(file_collection) }

  context '#open_nodes_grouped_by_day' do

    let (:reported) { reporter.open_nodes_grouped_by_day }

    it "extracts the correct dates and in the correct order" do
      dates = reported.map {|e| e[:date] }
      dates.should == ["2012-02-01", "2012-02-03", "2012-02-05"]
    end
    it "should group the nodecounts correctly" do
      nodecount_per_date = reported.map { |e| [e[:date], e[:nodes].length] }
      nodecount_per_date.should == [["2012-02-01", 2], ["2012-02-03", 1], ["2012-02-05", 1]]
    end
    it "should result in the following subhashes" do
      reported.should ==
         [{:date=>"2012-02-01",
           :nodes=>
            [{:title=>"org-node",
              :content=>"org-node content",
              :todo_state=>"TODO",
              :date=>"2012-02-01 00:00",
              :stars=>1},
             {:title=>"org-node",
              :content=>"org-node content",
              :todo_state=>"TODO",
              :date=>"2012-02-01 00:00",
              :stars=>3}]},
          {:date=>"2012-02-03",
           :nodes=>
            [{:title=>"org-node",
              :content=>"org-node content",
              :todo_state=>"TODO",
              :date=>"2012-02-03 00:00",
              :stars=>2}]},
          {:date=>"2012-02-05",
           :nodes=>
            [{:title=>"org-node",
              :content=>"org-node content",
              :todo_state=>"TODO",
              :date=>"2012-02-05 00:00",
              :stars=>2}]}]
    end
    it "it ignores the DONE task" do
      dates = reported.map {|e| e[:date] }
      dates.should_not include("2012-06-01")
    end
  end

end
