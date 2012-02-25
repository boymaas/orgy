require 'configuration'

describe "org-mode configuration" do
  before do
    load 'spec/configuration/default.rb'
  end
  let (:config) { Configuration.for('org-mode') }

  it "should load the configuration file" do
    config.org_mode_files.should == [
      "spec/configuration/example-org-file-00.org",
      "spec/configuration/example-org-file-01.org" ]
  end
end
