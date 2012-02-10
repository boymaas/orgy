module OrgMode
  module Reporters
    class Agenda
      attr_accessor :file_collection
      def initialize(file_collection)
        @file_collection = file_collection 
      end

      # Public: returns open nodes grouped by day
      #
      # Returns an Array of Hash-es like [{:date => '%Y-%m-%d', :nodes =>
      # [OrgMode::Node]}] ready to be used by fe Mustache
      def open_nodes_grouped_by_day
        # Get all nodes from all files
        # extract scheduled items which are not done
        nodes_of_interest = file_collection.scheduled_nodes
        nodes_of_interest = nodes_of_interest.select(&:open?)

        noi_per_day = nodes_of_interest.group_by { |noi| noi.date.strftime('%Y-%m-%d') }
       
        noi_per_day.keys.sort.map do |date|
          { :date => date, :nodes => noi_per_day[date].map { |n| node_to_hash(n) } }
        end
      end

      private

    def node_to_hash(node)
      rv = {}
      %w[title content todo_state date stars].each do |k|
        rv[:"#{k}"] = node.send(:"#{k}") 
      end
      rv[:date] = rv[:date].strftime('%Y-%m-%d %H:%M') if rv[:date]
      rv
    end

    end
  end
end
