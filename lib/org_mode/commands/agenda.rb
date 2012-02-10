require 'org_mode/parser'

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

      @parsed_files = []
      args.each do |file|
        buffer = File.open(file).read
        @parsed_files << OrgMode::FileParser.parse(buffer) 
      end

      # Get all nodes from all files
      # extract scheduled items which are not done
      nodes_of_interest = @parsed_files.map {|file| file.scheduled_nodes}.flatten
      nodes_of_interest.reject!(&:done?)
      noi_per_day = nodes_of_interest.group_by { |noi| noi.date.strftime('%Y-%m-%d') }

      tmpl_vars = {}
      tmpl_vars[:noi_per_date] = noi_per_day.keys.sort.map do |date|
        {:date => date, :nodes => noi_per_day[date] }
      end

      puts Mustache.render <<-eos.strip_indent(8), tmpl_vars
        Agenda ()
        {{#noi_per_date}}
          {{date}}
          {{#nodes}}
            {{todo_state}}{{title}}
          {{/nodes}}
          {{/noi_per_date}}
      eos

    end
  end
end
