require 'org_mode/configuration'

def load_or_setup_default_configuration
  dirname, fname = ENV['ORG_MODE_RC_DIR'], ENV['ORG_MODE_RC_FNAME']
  $config = OrgMode::Configuration.
    load(dirname, fname)
rescue OrgMode::Configuration::NonExistant => e
  $config = OrgMode::Configuration.
    create_default_config(dirname, fname)
rescue OrgMode::Configuration::Error => e
  puts "Problem loading configuration: #{e}"
  puts "Fix it first, and run me again ..."
  exit
end

load_or_setup_default_configuration
