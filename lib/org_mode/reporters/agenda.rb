require 'facets/to_hash'
require 'facets/ostruct'

module OrgMode
  module Reporters
    class Agenda
      attr_accessor :file_collection
      def initialize(file_collection)
        @file_collection = file_collection 
      end

      # Public: returns open nodes grouped by day
      # ordered by date
      #
      # Returns an Array of Hash-es like 
      # [{:date => '%Y-%m-%d', :nodes => [{ .. }]}]
      # ready to be used by fe Mustache
      def open_nodes_grouped_by_day
        # Get all nodes from all files
        # extract scheduled items which are not done
        # discard all DONE items
        nodes_of_interest = file_collection.scheduled_nodes.select(&:open?)

        # group them by date
        noi_per_day = nodes_of_interest.group_by { |noi| noi.date.strftime('%Y-%m-%d') }
       
        # build a nice orderd struct
        noi_per_day.keys.sort.map do |date|
          { :date => date, :nodes => noi_per_day[date].map { |n| node_to_hash(n) } }
        end.map(&:to_ostruct)

      end

      private

    def node_to_hash(node)
      rv = [:title, :content, :todo_state, :date, :date_start_time, :date_end_time, :stars, :appointment?].
        map { |k| [ k, node.send(k) ] }.to_h

      rv[:date] = rv[:date].strftime('%Y-%m-%d %H:%M') if rv[:date]
      rv[:date_start_time] = rv[:date_start_time].strftime('%H:%M') if rv[:date_start_time]
      rv[:date_end_time] = rv[:date_end_time].strftime('%H:%M') if rv[:date_end_time]
      rv[:node] = node
      rv.to_ostruct
    end

    end
  end
end
