require 'timecop'

Given /^we have an org\-file with the following content$/ do |string|
  @org_file = Tempfile.new('org_file')
  @org_file.write(string)
  @org_file.flush
end

When /^the script is called with "([^"]*)"( should fail)?$/ do |argv, should_fail|
  org_mode_args = []
  org_mode_args << argv if argv
  org_mode_args << @org_file.path if @org_file

  begin
    @stdout, = org_mode_script(*org_mode_args)
  rescue OrgModeScriptError => script_error
    raise unless should_fail
    @script_error = script_error
  end
end

Given /^we have an environment containing:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.raw.each do |k,v|
    ENV[k] = v
  end
end

Given /^I have an empty tmp dir 'features\/tmp'$/ do
  %x[rm -r features/tmp] 
  %x[mkdir features/tmp] 
end

Given /^date is "([^"]*)"$/ do |date_string|
  Timecop.freeze(Date.parse(date_string))
end

When /^the script is executed on the org-file$/ do
  @stdout, = org_mode_script(:agenda, @org_file.path)
end

Then /^the output should be$/ do |string|
  @stdout.should == string
end
Then /^the output should contain "([^""]*)"$/ do |pattern|
  @stdout.should match(pattern)
end
Then /^the output should not contain "([^""]*)"$/ do |pattern|
  @stdout.should_not match(pattern)
end

Then /^the error should be$/ do |string|
  @script_error.stderr.chomp.should == string
end
