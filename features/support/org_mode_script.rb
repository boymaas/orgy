require 'tempfile'
require 'ruby-debug'
require 'open3'

class OrgModeScriptError < StandardError;
  attr_accessor :stdout, :stderr, :status, :cmd

  def initialize(stdout, stderr, status, cmd)
    @stdout = stdout
    @stderr = stderr
    @status = status
    @cmd = cmd
    super("Failed command: #{cmd}")
  end
  
  def message
    <<-eom.gsub(/^\s{4}/, '')
      Failed command: #{cmd}
      Stderr:
        #{@stderr.empty? ? 'None' : @stderr}
      Stdout:
        #{@stdout.empty? ? 'None' : @stdout}
    eom
  end

end

# Private: runs org-mode binary and captures output
#
# builds command out of parameters and calls capturing
# stdout/stderr and the exit status
#
# Raises an OrgModeScriptError when status is not success
#   OrgModeScriptError contains all the information on the command
#
# Returns stdout as String, stderr as String, status as Process::Status
def org_mode_script(cmd, *params)

  # build command
  cmd = %[bin/org-mode #{cmd} #{params * ' '}]

  stdout, stderr, status = Open3.capture3(cmd)

  unless status.success?
    raise OrgModeScriptError.new(stdout, stderr, status, cmd)
  end

  return [stdout.chomp, stderr, status]
end
