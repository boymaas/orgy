require 'org_mode/commands/update'
require 'lib/org_mode/commands/helpers'

describe OrgMode::Commands::Update do
  before do
    @cmd = OrgMode::Commands::Update.new
  end

  context '#execute' do
      it 'reformats a file correctly' do
        org_file = write_into_tempfile <<-eos.strip_indent(10)
          * TODO Scheduled task <1-1-2012 Wed 15:15>
        eos
        execute_and_compare_stdout_with @cmd, [org_file.path], stub, <<-eos.strip_indent(10)
          * TODO <2012-01-01 Sun 15:15> Scheduled task
        eos
      end
  end
end
