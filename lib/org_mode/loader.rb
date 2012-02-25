class OrgMode::Loader
  # Public: loads and parses multiple files
  #
  # Returns OrgMode::FileCollection
  def self.load_and_parse_files paths
    org_mode_files = paths.map {|f| load_and_parse_file(f) } 
    OrgMode::FileCollection.new(org_mode_files)
  end

  # Public: loads and parse a file
  #
  # Returns OrgMode::File
  def self.load_and_parse_file path
    f = File.open(path)
    OrgMode::FileParser.parse(f.read)
  end
end
