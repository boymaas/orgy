require 'org_mode'
require 'facets/kernel/blank'

module OrgMode
  module Formatters
    class Textual
      def initialize(org_file)
        @org_file = org_file
      end

      def format
        [ @org_file.header,
          @org_file.nodes.map {|n| format_node(n)} * "\n",
          @org_file.footer ].reject(&:blank?) * "\n\n"
      end

      def format_node(node)
        [format_title(node), format_content(node)].reject(&:blank?) * "\n" 
      end

      def format_title(node)
        stars = "*" * node.stars
        [stars, node.todo_state, format_date(node), node.title].reject(&:blank?) * ' '
      end

      def format_content(node)
        node.content.lines.map do |l|
          [" " * node.indent, l].join
        end.join
      end

      def format_date(node)
        date = if node.date_end_time
                 "#{node.date_start_time.strftime('%Y-%m-%d %a %H:%M')}-#{node.date_end_time.strftime('%H:%M')}"
               elsif node.date_start_time
                 "#{node.date_start_time.strftime('%Y-%m-%d %a %H:%M')}"
               elsif node.date
                 "#{node.date.strftime('%Y-%m-%d %a')}"
               else
                 nil
               end

        date ? "<#{date}>" : nil
      end

    end
  end
end
