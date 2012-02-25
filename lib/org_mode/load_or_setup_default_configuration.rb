require 'org_mode/configuration'
begin
  $config = OrgMode::Configuration.load
rescue OrgMode::Configuration::NonExistant => e
  OrgMode::Configuration.create_default_config
rescue OrgMode::Configuration::Error => e
  puts "Problem loading configuration: #{e}"
  puts "Fix it first, and run me again ..."
  exit
end
