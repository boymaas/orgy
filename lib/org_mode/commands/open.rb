module OrgMode::Commands
  class Open
    # Private: executes the open command
    # opens all org-files in vim sessions
    #
    # args - list of filenames
    # options - switches set by the app
    #
    # Returns nothing
    def execute(args, options)
      $config.org_mode_files

      exec %[vim], *$config.org_mode_files
    end
  end
end
