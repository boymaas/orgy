require 'org_mode/parser'
require 'org_mode/loader'
require 'org_mode/formatters/textual'
require 'org_mode/processors/archive_done'

module OrgMode::Commands
  class Update
    def execute(args, options)
      org_file = OrgMode::Loader.load_and_parse_file(args[0])

      if options.archive_done
        org_file = OrgMode::Processors::ArchiveDone.new(org_file).process
      end

      org_formatter = OrgMode::Formatters::Textual.new(org_file)

      puts org_formatter.format

    rescue StandardError => e
      puts "Encountered a little problem: #{e}"
    end
  end
end
