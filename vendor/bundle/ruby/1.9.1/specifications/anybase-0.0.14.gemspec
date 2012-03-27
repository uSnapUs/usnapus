# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{anybase}
  s.version = "0.0.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joshual Hull", "Brad Gessler"]
  s.date = %q{2011-12-20}
  s.description = %q{Numbers from anybase to anybase}
  s.email = ["joshbuddy@gmail.com", "brad@bradgessler.com"]
  s.files = ["spec/from_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/to_spec.rb", "spec/util_spec.rb"]
  s.homepage = %q{http://github.com/joshbuddy/anybase}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{anybase}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Numbers from anybase to anybase}
  s.test_files = ["spec/from_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/to_spec.rb", "spec/util_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
