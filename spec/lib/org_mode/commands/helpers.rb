require 'tempfile'
require 'core_ext/string'
require 'support/write_into_tempfile'
require 'capture_stdout'

# Helper to execute agenda and compare the output
def execute_and_compare_stdout_with cmd, args, options, expected_output
  output = capture_stdout do
    cmd.execute(args, options)
  end
  output.should == expected_output
end
def execute_and_output_should_contain cmd, args, options, *expected_output
  output = capture_stdout do
    cmd.execute(args, options)
  end
  expected_output.each do |pattern|
    output.should match( pattern )
  end
end
