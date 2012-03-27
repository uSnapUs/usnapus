# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pusher}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pusher"]
  s.date = %q{2012-01-27}
  s.description = %q{Wrapper for pusher.com REST api}
  s.email = ["support@pusher.com"]
  s.files = ["spec/channel_spec.rb", "spec/client_spec.rb", "spec/spec_helper.rb", "spec/web_hook_spec.rb"]
  s.homepage = %q{http://github.com/pusher/pusher-gem}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Pusher API client}
  s.test_files = ["spec/channel_spec.rb", "spec/client_spec.rb", "spec/spec_helper.rb", "spec/web_hook_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_runtime_dependency(%q<ruby-hmac>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<signature>, ["~> 0.1.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<em-http-request>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_dependency(%q<ruby-hmac>, ["~> 0.4.0"])
      s.add_dependency(%q<signature>, ["~> 0.1.2"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<em-http-request>, ["~> 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, ["~> 1.0"])
    s.add_dependency(%q<ruby-hmac>, ["~> 0.4.0"])
    s.add_dependency(%q<signature>, ["~> 0.1.2"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<em-http-request>, ["~> 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
