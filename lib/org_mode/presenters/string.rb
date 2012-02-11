require 'mustache'

module OrgMode
  module Presenters
    module Agenda

      class Textual
        def initialize reporter
          @agenda_reporter = reporter
        end

        def by_date
          tmpl_vars = {}
          tmpl_vars[:noi_per_date] = @agenda_reporter.open_nodes_grouped_by_day

          Mustache.render <<-eos.strip_indent(10), tmpl_vars
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
  end
end
