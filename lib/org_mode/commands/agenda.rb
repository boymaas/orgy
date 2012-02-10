require 'org_mode/parser'
require 'org_mode/loader'
require 'org_mode/reporters/agenda'

require 'core_ext/string'
require 'mustache'

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

      tmpl_vars = {}
      tmpl_vars[:noi_per_date] = agenda_reporter.open_nodes_grouped_by_day

      puts Mustache.render <<-eos.strip_indent(8), tmpl_vars
        Agenda ()
        {{#noi_per_date}}
          {{date}}
          {{#nodes}}
            {{todo_state}}{{title}}
          {{/nodes}}
          {{/noi_per_date}}
      eos

    rescue SystemCallError => e
      puts "Encountered a little problem: #{e}"
    end
  end
end
