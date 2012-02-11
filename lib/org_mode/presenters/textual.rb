require 'mustache'

module OrgMode
  module Presenters
    module Agenda

      class Textual
        def initialize reporter
          @agenda_reporter = reporter
        end

        def open_items_per_day
          tmpl_vars = {}
          tmpl_vars[:noi_per_date] = @agenda_reporter.open_nodes_grouped_by_day


          Mustache.render <<-eos.strip_indent(10), tmpl_vars
          {{#noi_per_date}}
            {{date}}
            {{#nodes}}
            {{#appointment?}}
            {{#date_end_time}}
              {{date_start_time}}-{{date_end_time}} {{todo_state}}{{title}}
            {{/date_end_time}}
            {{^date_end_time}}
              {{date_start_time}}       {{todo_state}}{{title}}
            {{/date_end_time}}
            {{/appointment?}}
            {{^appointment?}}
              ALL-DAY     {{todo_state}}{{title}}
            {{/appointment?}}
            {{/nodes}}
            {{/noi_per_date}}
          eos
        end

      end
    end
  end
end
