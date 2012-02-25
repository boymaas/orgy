Before do
  %x[rm -r features/fixtures/tmp]
  %x[mkdir features/fixtures/tmp]
  ENV['ORG_MODE_RC_DIR'] = 'features/fixtures/tmp' 
  ENV['ORG_MODE_RC_FNAME'] = 'orgmoderc'         
end
