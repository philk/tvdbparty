# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tvdbparty}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Kates"]
  s.date = %q{2008-12-03}
  s.description = %q{TODO}
  s.email = %q{me@philkates.com}
  s.files = ["lib/tvdbmapper.rb", "lib/tvdbparty.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/philk/tvdbparty}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<curb>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<curb>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<curb>, [">= 0"])
  end
end
