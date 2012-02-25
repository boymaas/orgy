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
    
  it "determines correct path" do
    default_config.send(:path).to_s.
      should match(%r[org_mode/configuration/defaultrc\.rb$]) 
  end

  it "loads correct content" do
    default_config.send(:content).
      should match(/Daniel San/)
  end

  it "writes the content if asked for" do
    default_config.stub(:content => 'test-content')
    open_file = stub(:open_file)
    File.should_receive(:open).
      and_return(open_file)
    open_file.should_receive(:write).
      with('test-content')

    default_config.write_to('/tmp/filename-dont-matter')
  end
end
