require 'org_mode/parser'
require 'org_mode/loader'
require 'org_mode/reporters/agenda'
require 'org_mode/presenters/textual'

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

      file_collection = OrgMode::Loader.load_and_parse_files(*args)
      agenda_reporter = OrgMode::Reporters::Agenda.new(file_collection)
      text_presenter  = OrgMode::Presenters::Agenda::Textual.new(agenda_reporter)

      puts "Agenda: open items grouped by day"
      puts text_presenter.open_items_per_day

    rescue SystemCallError => e
      puts "Encountered a little problem: #{e}"
    end
  end
end
