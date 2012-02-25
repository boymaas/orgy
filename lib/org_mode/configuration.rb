require 'pathname'
require 'configuration'
require 'core_ext/string'
require 'date'

module OrgMode
  class DefaultOrgfile
    def self.content(tmpl_vars={})
      return <<-EOF.strip_indent(8)
       This is your default orgmode agenda file, the orgmode script
       finds this file since it's configured in #{tmpl_vars.fetch(:target_path)}

       * TODO Configure orgmoderc file in #{tmpl_vars.fetch(:target_path)} <#{DateTime.now.strftime('%Y-%m-%d %a')}>
       EOF
    end
  end

  class DefaultConfiguration
    attr_reader :file

    def write_to(target_path)
      @file ||= ::File.open(target_path, 'w+')
      @file.write(content)
      @file.flush

      dirname = ::File.dirname(target_path)
      config_dir = "#{dirname}/.orgmode"
      %x[mkdir #{config_dir}]

      default_org_file = ::File.open("#{config_dir}/gtd.org", 'w+')
      default_org_file.write(
        DefaultOrgfile.content(:target_path => target_path))
      default_org_file.flush
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
    # Returns the default config
    def self.create_default_config(base_dir=nil,file_name=nil)
      new_config = Configuration.new(base_dir,file_name)
      DefaultConfiguration.write_to( new_config.path )
      return new_config.read_and_evaluate
    end
  end
end
