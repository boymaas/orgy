source "http://rubygems.org"

# Specify your gem's dependencies in org_mode.gemspec
gemspec

gem "commander"
gem "facets"
gem "mustache"
gem "colorize"

group :development do
  if RUBY_VERSION =~ /^1\.9/
    gem "ruby-debug19"
  else
    gem "ruby-debug"
  end
end

group :test do
  gem "rspec", "~> 2.8.0"
  gem "cucumber"
  gem "timecop"
  gem "guard-cucumber"
  gem "popen4"
end


