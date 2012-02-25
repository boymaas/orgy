require 'org_mode/parser'
require 'org_mode/loader'
require 'org_mode/formatters/textual'
require 'org_mode/processors/archive_done'
require 'org_mode/file_tools'

module OrgMode::Commands
  class Update

    def execute(args, options)
      # use supplied file-name 
      # or use files out of configuration
      args = OrgMode::Configuration.org_mode_files if args.blank?

      args.each do |file_path|
        OrgMode::FileTools.backup(file_path)

        org_file = OrgMode::Loader.load_and_parse_file(file_path)

        if options.archive_done
          org_file = OrgMode::Processors::ArchiveDone.new(org_file).process
        end

        org_formatter = OrgMode::Formatters::Textual.new(org_file)

        OrgMode::FileTools.spit_into_file(org_formatter.format, file_path)
      end

    rescue StandardError => e
      puts "Encountered a little problem: #{e}"
    end
  end
end
