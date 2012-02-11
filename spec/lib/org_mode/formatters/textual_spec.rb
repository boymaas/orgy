require 'org_mode/formatters/textual'
require 'support/blueprints'

describe OrgMode::Formatters::Textual do
  let(:org_file) do
    nodes = []
    files = []
    nodes << OrgMode::Node.make(:stars => 1, 
                                :todo_state => 'DONE', 
                                :date => Date.parse('2012-06-01'))

    # make helper for this
    date = DateTime.parse('2012-02-01')
    date_start = DateTime.parse('2012-02-01 15:00')
    date_end = DateTime.parse('2012-02-01 16:00')
    nodes << OrgMode::Node.make(:stars => 2, :date=>Date.parse('2012-02-03'))
    nodes << OrgMode::Node.make(:stars => 3, :date=>date_start,
                                             :date_end_time=>date_end,
                                             :date_start_time=>date_start)
    OrgMode::File.make(:nodes => nodes)
  end


  context '#format' do
    before do
      formatter = OrgMode::Formatters::Textual.new(org_file) 
      @output = formatter.format
    end

    it "is formatted as expected" do
      @output.should == <<-eos.gsub(/^ {1,8}/,'').chomp
        aheader
        
        * DONE <2012-06-01 Fri> org-node
          org-node content
        ** TODO <2012-02-03 Fri> org-node
           org-node content
        *** TODO <2012-02-01 Wed 15:00-16:00> org-node
            org-node content
        
        afooter
      eos
    end
  end

end
