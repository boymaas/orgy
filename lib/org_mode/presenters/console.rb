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
            now = DateTime.now
            puts "Agenda: open items grouped by day [#{now.strftime('%Y-%m-%d %H:%M')}]".yellow.underline
            puts
            ongbd = @agenda_reporter.open_nodes_grouped_by_day
            ongbd.each do |e|
              puts "#{e.date}".blue.underline
              e.nodes.each do |n|
                color = :green
                color = :red if n.date_start_time && n.node.date_start_time < now
                color = :red if n.date && n.node.date < now
                  
                puts "  " + node_line(n).send(color)
              end
              puts
            end
          end
        end

        private

        def node_line(n)
          title = [n.todo_state, n.title].reject(&:nil?) * ' '
          if n.appointment?
            if n.date_end_time
              "%s-%s %s" % [n.date_start_time, n.date_end_time, title]
            else
              "%s       %s" % [n.date_start_time, title]
            end
          else
            "ALL-DAY     %s" % [title]
          end
        end

      end
    end
  end
end
