require "org_mode/version"

module OrgMode
  # Your code goes here...
  class Parser
    NodeTitle = %r{ 
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
        b, n, e =  Parser.parse_buffer(buffer)
        n.map! { |e| Node.new(*e) }
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
        tokens = buffer.split(NodeTitle).map(&:rstrip)
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
  
  class File
    attr_accessor :header, :nodes, :footer
    def initialize(header, nodes, footer)
      @header = header
      @footer = footer
      @nodes = nodes
    end
  end

  class Node
    attr_accessor :title, :content, :stars, :indent, :date, :todo_state
    
    def initialize(title, content)
      @title = title
      @content = content
      parse
    end

    private

    def parse
      parse_title
      parse_extract_dates
    end

    def parse_title
      matches = @title.match( /^(\*+)\s+(TODO|DONE)?(.*)$/ )
      @stars      = matches[1].length
      @todo_state = matches[2]
      @title      = matches[3]
      @indent     = @stars + 1
    end

    DateRegexp = /<(\d+-\d+-\d+ (\w{3})(\s\d+:\d+)?)>/
    def parse_extract_dates
       @date = title.match(DateRegexp).to_a[1] 
       @title = title.gsub(DateRegexp, '') 

       @date &&= DateTime.parse(@date)
    end
  end
end


