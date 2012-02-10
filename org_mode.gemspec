# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "org_mode/version"

Gem::Specification.new do |s|
  s.name        = "org_mode"
  s.version     = OrgMode::VERSION
  s.authors     = ["Boy Maas"]
  s.email       = ["boy.maas@gmail.com"]
  s.homepage    = "https://github.com/boymaas/orgy"
  s.summary     = %q{Parses and does all kinds of tricks with org-mode files}
  s.description = %q{Org-mode parser, presenter, and reformatter. Read more about it on the github pages.}

  s.rubyforge_project = "org_mode"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_development_dependency "rake", ["~> 0.9"]
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "commander", ["~> 4.0"]
  s.add_runtime_dependency "facets", ["~> 2.9"]
  s.add_runtime_dependency "mustache", ["~> 0.99"]
end
