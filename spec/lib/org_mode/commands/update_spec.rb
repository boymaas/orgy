require 'org_mode/commands/update'
require 'lib/org_mode/commands/helpers'

describe OrgMode::Commands::Update do
  before do
    @cmd = OrgMode::Commands::Update.new
  end

  context '#execute' do
    context 'without options' do
      it 'reformats a file correctly' do
        org_file = write_into_tempfile <<-eos.strip_indent(10)
          * TODO Scheduled task <1-1-2012 Wed 15:15>
        eos
        execute_and_compare_stdout_with @cmd, [org_file.path], stub(:archive_done => false), <<-eos.strip_indent(10)
          * TODO <2012-01-01 Sun 15:15> Scheduled task
        eos
      end
    end
    context 'option --archive-done' do
      it 'archives the subtree as expected' do
        org_file = write_into_tempfile <<-eos.strip_indent(10)
          * TODO Scheduled task <1-1-2012 Wed 15:15>
          ** DONE Scheduled child task <1-1-2012 Wed 12:15>
          *** TODO Scheduled child of child
        eos
        execute_and_compare_stdout_with @cmd, [org_file.path], stub(:archive_done => true), <<-eos.strip_indent(10)
          * TODO <2012-01-01 Sun 15:15> Scheduled task
          * Archived
            This node contains archived items. Appended
            due to calling the script with update --archive-done
          
          ** DONE <2012-01-01 Sun 12:15> Scheduled child task
          *** TODO Scheduled child of child
        eos
      end
    end
  end
end
