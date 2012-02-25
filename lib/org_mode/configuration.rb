require 'pathname'
require 'configuration'
require 'core_ext/string'
require 'date'

module OrgMode
  module FileOperations
    def spit_into_file(path, content)
      f = ::File.open(path, 'w+')
      f.write(content)
      f.flush
      f.close
    end
  end

  class DefaultOrgfile
    extend FileOperations

    class << self
      def content(tmpl_vars={})
        return <<-EOF.strip_indent(10)
         This is your default orgmode agenda file, the orgmode script
         finds this file since it's configured in #{tmpl_vars.fetch(:target_path)}

         * TODO Configure orgmoderc file in #{tmpl_vars.fetch(:target_path)} <#{DateTime.now.strftime('%Y-%m-%d %a')}>
       EOF
      end

      def write_to(path, tmpl_vars={})
        spit_into_file(path, content(tmpl_vars))
      end
    end
  end

  class DefaultRcFile
    extend FileOperations

    class << self
      def content
        @content ||= ::File.open(default_rc_path).read
      end

      def write_to(target_path)
        spit_into_file(target_path, content)
      end

      private

      def default_rc_path 
        ::File.dirname(__FILE__) + '/configuration/defaultrc.rb'
      end
    end
  end

  class DefaultConfiguration

    def write_to(target_path)
      dirname = ::File.dirname(target_path)
      config_dir = "#{dirname}/.orgmode"
      %x[mkdir #{config_dir}]

      DefaultOrgfile.write_to("#{config_dir}/gtd.org", :target_path=>target_path)
      DefaultRcFile.write_to(target_path)
    end

    def self.write_to(target_path)
      new.write_to(target_path)
    end
  end

  class Configuration
    class Error < StandardError; end
    class ScriptError < Error; end
    class IOError < Error; end
    class NonExistant < Error; end

    ## Class method caller
    class << self
      def load(base_dir=nil, file_name=nil)
        @singleton = new(base_dir,file_name)
        @config = @singleton.read_and_evaluate
      end

      def path
        @singleton.path
      end

      def backup_dir
        @singleton.base_dir + '.orgmode/backups'
      end

      # forward all to our singleton
      def method_missing(f,*a)
        if @config.respond_to?(f)
          return @config.send(f, *a) 
        end
        super
      end
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
