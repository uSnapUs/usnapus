# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{postmark-rails}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Petyo Ivanov", "Ilya Sabanin"]
  s.date = %q{2010-11-22}
  s.description = %q{Use this plugin in your rails applications to send emails through the Postmark API}
  s.email = %q{ilya@wildbit.com}
  s.files = ["spec/fixtures/models/test_mailer.rb", "spec/postmark-rails_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://postmarkapp.com}
  s.post_install_message = %q{
      ==================
      Thanks for installing the postmark-rails gem. If you don't have an account, please sign up at http://postmarkapp.com/.
      Review the README.rdoc for implementation details and examples.
      ==================
    }
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Postmark adapter for ActionMailer}
  s.test_files = ["spec/fixtures/models/test_mailer.rb", "spec/postmark-rails_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>, [">= 0"])
      s.add_runtime_dependency(%q<postmark>, [">= 0.9.0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<actionmailer>, [">= 0"])
      s.add_dependency(%q<postmark>, [">= 0.9.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionmailer>, [">= 0"])
    s.add_dependency(%q<postmark>, [">= 0.9.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
