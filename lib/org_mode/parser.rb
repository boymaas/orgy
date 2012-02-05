require 'org_mode'

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

      def parse(buffer)
        b, n, e =  FileParser.parse_buffer(buffer)
        n.map! { |m| NodeParser.parse(*m) }
        return File.new(b,n,e)
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
          nodes << Array.new(2) { tokens.shift }
        end

        nodes.map! { |t,c| [t,c[1..-1] || ''] }

        [ beginning_of_file, nodes, "" ]
      end
    end
  end

  class NodeParser

    class << self

      def parse(title,content)
        node = OrgMode::Node.new
        parse_title(node, title)
        parse_extract_dates(node)
        parse_content(node, content)
        node
      end

      def parse_title(node,title)
        matches = title.match( /^(\*+)\s+(TODO|DONE)?(.*)$/ )
        node.stars      = matches[1].length
        node.todo_state = matches[2]
        node.title      = matches[3]
        node.indent     = node.stars + 1
      end

      RxDateRegexp = /<(\d+-\d+-\d+ (\w{3})(\s\d+:\d+)?)>/
        def parse_extract_dates(node)
          extracted_date = node.title.match(RxDateRegexp).to_a[1] 
          node.title = node.title.gsub(RxDateRegexp, '') 

          if extracted_date
            node.date = DateTime.parse(extracted_date)
          end
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
