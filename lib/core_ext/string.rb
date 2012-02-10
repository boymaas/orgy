class String
  def strip_indent(count)
    self.gsub(/^\s{#{count}}/,'')
  end
end
