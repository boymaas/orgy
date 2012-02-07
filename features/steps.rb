Given /^we have an org\-file with the following content$/ do |string|
  @org_file = Tempfile.new('org_file')
  @org_file.write(string)
  @org_file.flush
end

When /^the script is executed on the org-file$/ do
  @stdout, = org_mode_script(:agenda, @org_file.path)
end

Then /^the output should be$/ do |string|
  @stdout.should == string
end
