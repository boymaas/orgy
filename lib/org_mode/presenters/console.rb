require 'colorize'

require 'capture_stdout'

module OrgMode
  module Presenters
    module Agenda

      class Console
        def initialize reporter
          @agenda_reporter = reporter
        end

        def open_items_per_day_colorized
          capture_stdout do
            puts "Agenda: open items grouped by day".yellow
            puts
            ongbd = @agenda_reporter.open_nodes_grouped_by_day
            ongbd.each do |e|
              puts "#{e.date}".red
              e.nodes.each do |n|
                title = [n.todo_state, n.title].reject(&:nil?) * ' '
                row = if n.appointment?
                  if n.date_end_time
                    "  #{n.date_start_time}-#{n.date_end_time} #{title}"
                  else
                    "  #{n.date_start_time}       #{title}"
                  end
                else
                  "  ALL-DAY     #{title}"
                end
                puts row.blue
              end
            end
          end
        end

      end
    end
  end
end
