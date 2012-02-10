require 'stringio'
 
def capture_stdout
  out = StringIO.new
  $stdout = out
  yield
  out.rewind
  return out.read
ensure
  $stdout = STDOUT
end
 
