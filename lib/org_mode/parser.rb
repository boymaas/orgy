# Public: Org File format parser
#
# A simple regexp based parser for orgfiles. Works by simply dividng
# the file in beginning, nodes, and ending. After this it will
# parse the individual nodes extracting remaining detailed information.
#
# Parser is decoupled from object model to make it easy to write updated
# parsers or use a database to serialize an org-mode file out of.
require 'org_mode'
require 'org_mode/node_utils'
require 'date'

module OrgMode
  class FileParser
    RxNodeTitle = %r{ 
      ^   # beginning of line
      (
        \*+ # multiple stars 
        \s+ # one or more whitespace
        .*  # anything
      )
      $   # untill _end of line
    }xs

    class << self

      # Public: parses buffer into nodes and
      # collects there in a OrgMode::File object
      #
      # Returns OrgMode::File object containing all
      # information of the file. 
      def parse(buffer)
        b, nodes, e  = parse_buffer(buffer)

        parsed_nodes = parse_nodes(nodes)
        root_nodes   = NodeUtils.convert_sequential_nodelist_into_tree(parsed_nodes)

        return File.new(b,root_nodes,e)
      end

      def parse_nodes(nodes)
        nodes.map do |title,content|
          NodeParser.parse(title,content) 
        end
      end

      def parse_buffer(buffer)
        beginning_of_file, nodes, ending_of_file =
          parse_into_tokens(buffer)
      end


      # Private: splits buffer into different parts
      #   First part is beginning of file
      #   Second part are the nodetitles in combination
      #   with the content
      #   Third part is the ending of the file
      # 
      # buffer - org mode data
      #
      # Returns beginning_of_file, nodes, and ending
      #   if beginning is not present and empy string is 
      #   returned. This function will never return nil
      # 
      def parse_into_tokens buffer
        tokens = buffer.split(RxNodeTitle).map(&:rstrip)
        beginning_of_file = tokens.shift || ''

        nodes = []
        while !tokens.empty?
          nodes << Array.new(2) { tokens.shift || '' }
        end

        nodes.map! { |t,c| [t,c[1..-1] || ''] }

        [ beginning_of_file, nodes, "" ]
      end
    end
  end

  class NodeParser

    class << self

      # Public: Parses a node in the org-mode file-format
      # 
      # title - a org-mode title, can contain date, todo statusses, tags
      #         everything specified in the org-mod file format
      # content - the content block, which can also contain org-mode format
      #
      # Return a OrgMode::Node containing all parsable information
      def parse(title,content)
        node = OrgMode::Node.new
        parse_title(node, title)
        parse_extract_dates(node)
        parse_content(node, content)
        node
      end

      private

      def parse_title(node,title)
        matches = title.match( /^(\*+)\s+(TODO|DONE)?(.*)$/ )
        node.stars      = matches[1].length
        node.todo_state = matches[2]
        node.title      = matches[3]
        #node.indent     = node.stars + 1
      end

      RxDateRegexp = /<(\d+-\d+-\d+)(?:\s(?:\w{3})?(?:\s(\d+:\d+))?)(?:-(\d+:\d+))?>/
        def parse_extract_dates(node)
          _, extracted_date, start_time, end_time = node.title.match(RxDateRegexp).to_a
          node.title = node.title.gsub(RxDateRegexp, '') 
          node.title.strip!

          node.date = DateTime.parse(extracted_date) if extracted_date
          node.date_start_time = DateTime.parse("#{extracted_date} #{start_time}") if start_time
          node.date_end_time = DateTime.parse("#{extracted_date} #{end_time}") if end_time
        end

      RxEmptyLine = /^\s*$/
        def parse_content(node,content)
          return unless content

          minimum_indent = ( content.lines.map {|l| l =~ /\S/ }.reject(&:nil?) + [node.indent] ).min
          content.gsub!(/^\s{#{minimum_indent}}/m, '')

            # remove empty lines at beginning and ending
            node.content = content.lines.
            drop_while {|e| e =~ RxEmptyLine}.
            reverse.
            drop_while {|e| e =~ RxEmptyLine}.
            reverse.
            join
        end
    end
  end
end
