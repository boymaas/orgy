require 'org_mode'

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
    it "should return a OrgMode::File" do
      parsed = OrgMode::FileParser.parse(org_data)
      parsed.class.should == OrgMode::File
    end
    it "parses the tree correctly" do
      # how do we test for this ... 
    end
  end
end

describe OrgMode::File do
  it "holds all the nodes"
  it "holds all the configuration data"
end

describe OrgMode::Node do
  context ".parse" do
    it "parses the title correctly"
    it "parses the content correctly"
    it "parses the date from the title correcty"
    it "parses the TODO DONE keywords correctly"
  end
end
