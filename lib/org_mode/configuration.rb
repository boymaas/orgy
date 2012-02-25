require 'pathname'
require 'configuration'

module OrgMode
  class DefaultConfiguration
    def write_to(target_path)
      ::File.open(target_path, 'w+').write(content)
    end

    def self.write_to(target_path)
      new.write_to(target_path)
    end

    private 

    def path 
      unless @path
        @path = 
          ::File.dirname(__FILE__) + '/configuration/defaultrc.rb'
        @path = Pathname.new(@path)
      end

      @path
    end

    def content
      @content ||= ::File.open(path).read
    end
  end

  class Configuration
    class Error < StandardError; end
    class ScriptError < Error; end
    class IOError < Error; end
    class NonExistant < Error; end

    ## Class method caller
    def self.load(base_dir=nil, file_name=nil)
      self.new(base_dir,file_name).read_and_evaluate
    end

    # Instance
    attr_reader :file_name, :base_dir, :path

    # Initializes loader and generates file-path
    def initialize(a_base_dir=nil, a_file_name=nil)
      @base_dir = Pathname.new(a_base_dir || ENV['HOME'])
      @file_name = Pathname.new(a_file_name || '.orgmoderc')
      @path = @base_dir + @file_name
    end


    # Reads a config file and avaluates
    # it.
    #
    # Returns a Configuration object
    def read_and_evaluate
      contents = ::File.open(path).read
      instance_eval <<-RUBY, path, 0
        ::Configuration.for('org-mode') do
          #{contents}
        end
      RUBY

      ::Configuration.for('org-mode')

    rescue ::Errno::ENOENT => e
      raise NonExistant, "config file does not exist"
    rescue ::IOError, ::SystemCallError => e
      raise IOError, "problem loading config: #{e}"
    rescue ::ScriptError => e
      raise ScriptError, "problem loading config: #{e}"
    end

    # Creates a minimal example configuration
    #
    # Returns nothing
    def self.create_default_config
      DefaultConfiguration.write_to(Configuration.new.path)
    end
  end
end
