# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{excon}
  s.version = "0.7.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["geemus (Wesley Beary)"]
  s.date = %q{2011-10-04}
  s.description = %q{EXtended http(s) CONnections}
  s.email = %q{geemus@gmail.com}
  s.homepage = %q{https://github.com/geemus/excon}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{excon}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{speed, persistence, http(s)}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shindo>, ["= 0.2.0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shindo>, ["= 0.2.0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shindo>, ["= 0.2.0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
