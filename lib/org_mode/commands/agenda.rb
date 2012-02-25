require 'org_mode/parser'
require 'org_mode/loader'
require 'org_mode/reporters/agenda'
require 'org_mode/presenters/console'

require 'core_ext/string'

module OrgMode::Commands
  class Agenda
    # Private: executes the agenda command
    # parses all the files
    #
    # args - list of filenames
    # options - switches set by the app
    #
    # Returns the restult to stdout
    def execute(args, options)

      files_to_parse = args
      if files_to_parse.empty?
        files_to_parse = $config.org_mode_files
      end

      file_collection = OrgMode::Loader.load_and_parse_files(files_to_parse)
      agenda_reporter = OrgMode::Reporters::Agenda.new(file_collection)
      console_presenter  = OrgMode::Presenters::Agenda::Console.new(agenda_reporter)

      puts console_presenter.open_items_per_day_colorized

    rescue SystemCallError => e
      puts "Encountered a little problem: #{e}"
    end
  end
end
