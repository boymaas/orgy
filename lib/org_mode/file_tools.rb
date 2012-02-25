require 'fileutils'

module OrgMode::FileTools
  extend self
  extend FileUtils

  def backup(file)
    mkdir_p backup_dir unless File.exist?(backup_dir)
    cp file, add_unique_extention(backup_path(file))
  end

  def spit_into_file(buffer, file)
    File.open(file, 'w') do |f|
     f.write(buffer) 
     f.flush
    end
  end

  def backup_path(file)
    backup_dir + ::File.basename(file)
  end
  

  def backup_dir
    OrgMode::Configuration.backup_dir
  end

  private

  def add_unique_extention(file)
    "%s.%d" % [ file, (_unique_extention(file)) ]
  end

  def _unique_extention(file)
    uid = _extract_unique_extentions(file).max
    uid ? uid + 1 : 0
  end

  def _extract_unique_extentions(file)
    Dir["#{ file }.*"].
      select {|p| /\.\d+$/ }.
      map { |p| p.match(/(\d+)$/)[1].to_i }
  end

end
