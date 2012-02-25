require 'lib/org_mode/configuration'

describe OrgMode::Configuration do
  context "no configuration present" do
    let (:config)  {
      OrgMode::Configuration.
        load('spec/configuration', 'orgmoderc-non-existant') }

    it "raises an error" do
      lambda { 
        config.org_mode_files 
      }.should raise_error(OrgMode::Configuration::NonExistant)
    end
  end
  context "configuration present" do
    let (:config)  {
      OrgMode::Configuration.
        load('spec/configuration', 'orgmoderc') }

    it "should set correct parameters" do
      config.org_mode_files.should == %W{
        spec/configuration/example-org-file-00.org
        spec/configuration/example-org-file-01.org
      }
    end

    it "should be accessible through the class" do
      OrgMode::Configuration.org_mode_files.should == %W{
        spec/configuration/example-org-file-00.org
        spec/configuration/example-org-file-01.org
      }
    end
  end
  context "wrong configuration present" do
    let (:config)  {
      OrgMode::Configuration.
        load('spec/configuration', 'orgmoderc-error') }

    it "should raise an error" do
      lambda { 
        config.org_mode_files 
      }.should raise_error(OrgMode::Configuration::ScriptError)
    end
  end

  context ".create_default_config" do
    it "should write it" do
      OrgMode::DefaultConfiguration.should_receive(:write_to)
      OrgMode::Configuration.create_default_config
    end
  end
end

describe OrgMode::DefaultConfiguration do
  let (:default_config) { OrgMode::DefaultConfiguration.new }
    
  it "writes the content if asked for" do
    %x[rm -r spec/tmp]
    %x[mkdir spec/tmp]
    target_path = 'spec/tmp/orgmoderc'

    default_config.write_to(target_path)

    File.exist?('spec/tmp/.orgmode').should be_true
    File.exist?('spec/tmp/.orgmode/gtd.org').should be_true
    File.exist?('spec/tmp/orgmoderc').should be_true

    File.open('spec/tmp/.orgmode/gtd.org').read.should == 
      OrgMode::DefaultOrgfile.
        content(:target_path => 'spec/tmp/orgmoderc')
  end
end
