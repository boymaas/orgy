def write_into_tempfile string
  tmpfile = Tempfile.new('org_mode_file')
  tmpfile.write(string)
  tmpfile.flush
  tmpfile
end
