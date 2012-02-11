require 'stringio'
 
def capture_stdout
  out = StringIO.new
  old_stdout = $stdout
  $stdout = out
  yield
  out.rewind
  return out.read
ensure
  $stdout = old_stdout
end
 
