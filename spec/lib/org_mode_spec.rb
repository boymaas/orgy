require 'org_mode'
require 'org_mode/parser'

# Parser
# ------
#
# Two way parser:
#   First pass
#     Find file settings
#     Find all nodes
#       Title and content tree structure
#   Second pass
#     Parse all nodes
#       (using information from file, ak TODO keywords)
#       Parse title
#       Parse content
#
#   Node
#     Title
#       TodoStateKeyword
#       Date
#     Content
#       CodeBlockParser
#       PlainTextParser
#
# Nodes
#   SettingsNode
#     settings_hash
#     SettingsAttachment
#   PlainTextNode
#     content
#   CodeBlockNode
#     language
#     content


# Private: Loads org example
# 
# name - takes part of filename
#
# Returns the contents of the file
def load_org_example name
  File.open("spec/data/org-file-#{name}.org").read
end

describe OrgMode::FileParser do
  context ".parse_into_tokens" do
    it "should divide data up correctly" do
      org_data = <<-org.gsub(/^\s{8}/,'')
        * First
        ** Second
      org
      b,n,e = OrgMode::FileParser.parse_into_tokens(org_data)
      b.should be_empty
      n.should == [["* First", ""], ["** Second", ""]]
      e.should be_empty
    end
    it "should handle nodes with content" do
      org_data = <<-org.gsub(/^\s{8}/,'')
        * First
          Content for first node
        ** Second
           Content for nested node
      org
      b,n,e = OrgMode::FileParser.parse_into_tokens(org_data)
      b.should be_empty
      n.should == [["* First", "  Content for first node"], ["** Second", "   Content for nested node"]]
      e.should be_empty
    end
    it "should handle content with no nodes" do
      org_data = <<-org.gsub(/^\s{8}/,'')
        Just some textfile without any nodes
      org
      b,n,e = OrgMode::FileParser.parse_into_tokens(org_data)
      b.should == 'Just some textfile without any nodes'
      n.should == []
      e.should be_empty
    end
    it "should take an empty string" do
      org_data = <<-org.gsub(/^\s{8}/,'')
      org
      b,n,e = OrgMode::FileParser.parse_into_tokens(org_data)
      b.should be_empty
      n.should == []
      e.should be_empty
    end
  end

  context ".parse" do
    let(:org_data) { load_org_example '01-simple-node-structure' }
    it "should just parse the file" do
      parsed = OrgMode::FileParser.parse(org_data)
    end
    context 'with a parsed org_file' do
      let(:org_file) { OrgMode::FileParser.parse(org_data) }

      it "should return an OrgMode::File" do
        org_file.should be_an_instance_of( OrgMode::File )
      end

      it "parses the tree correctly" do
        org_file.nodes.length.should == 12
      end

      it "has an empty beginning" do
        org_file.header.should be_empty
      end
      it "has an empty ending" do
        org_file.footer.should be_empty
      end
    end
  end
end

describe OrgMode::File do
  it "holds all the nodes"
  it "holds all the configuration data"
end

describe OrgMode::NodeParser do
  context ".parse" do
    context "title" do
      context "standard node title" do
        let(:node) {OrgMode::NodeParser.parse('** Standard node title', nil)}
        it "parses the title correctly" do
          node.title.should == 'Standard node title'
        end
        it "determines the correct stars" do
          node.stars.should == 2
        end
        it "determines the correct indent" do
          node.indent.should == 3
        end
      end
      context "level deeper node title" do
        let(:node) {OrgMode::NodeParser.parse('*** Standard node title one level deeper', nil)}
        it "parses the title correctly" do
          node.title.should == 'Standard node title one level deeper'
        end
        it "determines the correct stars" do
          node.stars.should == 3
        end
        it "determines the correct indent" do
          node.indent.should == 4
        end
      end
      context "node title with date" do
        let(:node) {OrgMode::NodeParser.parse('** Date node title <2012-02-02 Wed>', nil) }
        it "parses the date from the title correcty" do
          node.date.strftime('%Y-%m-%d').should == '2012-02-02'
        end
      end
      context "node title with date time" do
        let(:node) {OrgMode::NodeParser.parse('** Date node title <2012-02-03 Wed 15:15>', nil)}
        it "parses the date-time from the title correcty" do
          node.date.strftime('%Y-%m-%d %H:%M').should == '2012-02-03 15:15'
        end
      end
      context "parses TODO states correctly" do
        let(:node) {OrgMode::NodeParser.parse('** TODO Date node title', nil)}
        it "parses the TODO keyword correctly" do
          node.todo_state.should == 'TODO'
        end
        context "parses DONE state correctly" do
          let(:node) {OrgMode::NodeParser.parse('** DONE Date node title', nil)}
          it "parses the TODO keyword correctly" do
            node.todo_state.should == 'DONE'
          end
        end
      end
    end
    context "content indentation" do
      context "correctly indented" do
        before do
          org_title, *org_content = <<-eos.gsub(/^\s{10}/,'').lines.to_a
          *** Title
              Content belonging
              at a certain indent
              should be parsed correctly
          eos
          @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        end
        it "parses content and removes indent" do
          @node.content.should == <<-eos.gsub(/^\s{10}/,'')
          Content belonging
          at a certain indent
          should be parsed correctly
          eos
        end
      end
      context "too far" do
        before do
          org_title, *org_content = <<-eos.gsub(/^\s{10}/,'').lines.to_a
          *** Title
                Content belonging
                at a certain indent
                should be parsed correctly
          eos
          @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        end
        it "parses content and removes indent" do
          @node.content.should == <<-eos.gsub(/^\s{10}/,'')
            Content belonging
            at a certain indent
            should be parsed correctly
          eos
        end
      end
      context "indented in content block" do
        before do
          org_title, *org_content = <<-eos.gsub(/^\s{10}/,'').lines.to_a
          *** Title
              Content belonging
                at a certain indent
                should be parsed correctly
          eos
          @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        end
        it "parses content and removes indent" do
          @node.content.should == <<-eos.gsub(/^\s{10}/,'')
          Content belonging
            at a certain indent
            should be parsed correctly
          eos
        end
      end
      context "one row outdented" do
        before do
          org_title, *org_content = <<-eos.gsub(/^\s{10}/,'').lines.to_a
          *** Title
            Content belonging
              at a certain indent
              should be parsed correctly
          eos
          @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        end
        it "parses content and removes indent" do
          @node.content.should == <<-eos.gsub(/^\s{10}/,'')
          Content belonging
            at a certain indent
            should be parsed correctly
          eos
        end
      end
    end
    context "content whitespace" do
      it "removes whitespace at beginning" do
        org_title, *org_content = <<-eos.gsub(/^\s{8}/,'').lines.to_a
        *** Title
            
            
            
            Content belonging
            at a certain indent
            should be parsed correctly
        eos
        @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        @node.content.should == <<-eos.gsub(/^\s{8}/,'')
        Content belonging
        at a certain indent
        should be parsed correctly
        eos
      end
      it "removes whitespace at ending" do
        org_title, *org_content = <<-eos.gsub(/^\s{8}/,'').lines.to_a
        *** Title
            Content belonging
            at a certain indent
            should be parsed correctly
            
            
            
        eos
        @node = OrgMode::NodeParser.parse(org_title, org_content.join)
        @node.content.should == <<-eos.gsub(/^\s{8}/,'')
        Content belonging
        at a certain indent
        should be parsed correctly
        eos
      end
    end
  end
end
