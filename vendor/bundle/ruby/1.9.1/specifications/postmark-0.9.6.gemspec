# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{postmark}
  s.version = "0.9.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Petyo Ivanov", "Ilya Sabanin"]
  s.date = %q{2011-02-23}
  s.description = %q{Use this gem to send emails through Postmark HTTP API and retrieve info about bounces.}
  s.email = %q{ilya@wildbit.com}
  s.files = ["spec/bounce_spec.rb", "spec/postmark_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://postmarkapp.com}
  s.post_install_message = %q{
      ==================
      Thanks for installing the postmark gem. If you don't have an account, please sign up at http://postmarkapp.com/.
      Review the README.rdoc for implementation details and examples.
      ==================
    }
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Official Postmark API wrapper.}
  s.test_files = ["spec/bounce_spec.rb", "spec/postmark_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<fakeweb-matcher>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<fakeweb-matcher>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<fakeweb-matcher>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
  end
end
