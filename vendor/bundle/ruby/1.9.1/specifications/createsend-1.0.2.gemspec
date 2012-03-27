# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{createsend}
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Dennes"]
  s.date = %q{2011-10-31}
  s.description = %q{Implements the complete functionality of the createsend API.}
  s.email = ["jdennes@gmail.com"]
  s.files = ["test/campaign_test.rb", "test/client_test.rb", "test/createsend_test.rb", "test/fixtures/active_subscribers.json", "test/fixtures/add_subscriber.json", "test/fixtures/apikey.json", "test/fixtures/bounced_subscribers.json", "test/fixtures/campaign_bounces.json", "test/fixtures/campaign_clicks.json", "test/fixtures/campaign_listsandsegments.json", "test/fixtures/campaign_opens.json", "test/fixtures/campaign_recipients.json", "test/fixtures/campaign_summary.json", "test/fixtures/campaign_unsubscribes.json", "test/fixtures/campaigns.json", "test/fixtures/client_details.json", "test/fixtures/clients.json", "test/fixtures/countries.json", "test/fixtures/create_campaign.json", "test/fixtures/create_client.json", "test/fixtures/create_custom_field.json", "test/fixtures/create_list.json", "test/fixtures/create_list_webhook.json", "test/fixtures/create_segment.json", "test/fixtures/create_template.json", "test/fixtures/custom_api_error.json", "test/fixtures/custom_fields.json", "test/fixtures/deleted_subscribers.json", "test/fixtures/drafts.json", "test/fixtures/import_subscribers.json", "test/fixtures/import_subscribers_partial_success.json", "test/fixtures/list_details.json", "test/fixtures/list_stats.json", "test/fixtures/list_webhooks.json", "test/fixtures/lists.json", "test/fixtures/scheduled_campaigns.json", "test/fixtures/segment_details.json", "test/fixtures/segment_subscribers.json", "test/fixtures/segments.json", "test/fixtures/subscriber_details.json", "test/fixtures/subscriber_history.json", "test/fixtures/suppressionlist.json", "test/fixtures/systemdate.json", "test/fixtures/template_details.json", "test/fixtures/templates.json", "test/fixtures/timezones.json", "test/fixtures/unsubscribed_subscribers.json", "test/helper.rb", "test/list_test.rb", "test/segment_test.rb", "test/subscriber_test.rb", "test/template_test.rb"]
  s.homepage = %q{http://github.com/campaignmonitor/createsend-ruby/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A library which implements the complete functionality of v3 of the createsend API.}
  s.test_files = ["test/campaign_test.rb", "test/client_test.rb", "test/createsend_test.rb", "test/fixtures/active_subscribers.json", "test/fixtures/add_subscriber.json", "test/fixtures/apikey.json", "test/fixtures/bounced_subscribers.json", "test/fixtures/campaign_bounces.json", "test/fixtures/campaign_clicks.json", "test/fixtures/campaign_listsandsegments.json", "test/fixtures/campaign_opens.json", "test/fixtures/campaign_recipients.json", "test/fixtures/campaign_summary.json", "test/fixtures/campaign_unsubscribes.json", "test/fixtures/campaigns.json", "test/fixtures/client_details.json", "test/fixtures/clients.json", "test/fixtures/countries.json", "test/fixtures/create_campaign.json", "test/fixtures/create_client.json", "test/fixtures/create_custom_field.json", "test/fixtures/create_list.json", "test/fixtures/create_list_webhook.json", "test/fixtures/create_segment.json", "test/fixtures/create_template.json", "test/fixtures/custom_api_error.json", "test/fixtures/custom_fields.json", "test/fixtures/deleted_subscribers.json", "test/fixtures/drafts.json", "test/fixtures/import_subscribers.json", "test/fixtures/import_subscribers_partial_success.json", "test/fixtures/list_details.json", "test/fixtures/list_stats.json", "test/fixtures/list_webhooks.json", "test/fixtures/lists.json", "test/fixtures/scheduled_campaigns.json", "test/fixtures/segment_details.json", "test/fixtures/segment_subscribers.json", "test/fixtures/segments.json", "test/fixtures/subscriber_details.json", "test/fixtures/subscriber_history.json", "test/fixtures/suppressionlist.json", "test/fixtures/systemdate.json", "test/fixtures/template_details.json", "test/fixtures/templates.json", "test/fixtures/timezones.json", "test/fixtures/unsubscribed_subscribers.json", "test/helper.rb", "test/list_test.rb", "test/segment_test.rb", "test/subscriber_test.rb", "test/template_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, ["~> 1.0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.8"])
    else
      s.add_dependency(%q<fakeweb>, ["~> 1.3"])
      s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_dependency(%q<mocha>, ["~> 0.9"])
      s.add_dependency(%q<shoulda>, ["~> 2.11"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<hashie>, ["~> 1.0"])
      s.add_dependency(%q<httparty>, ["~> 0.8"])
    end
  else
    s.add_dependency(%q<fakeweb>, ["~> 1.3"])
    s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
    s.add_dependency(%q<mocha>, ["~> 0.9"])
    s.add_dependency(%q<shoulda>, ["~> 2.11"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<hashie>, ["~> 1.0"])
    s.add_dependency(%q<httparty>, ["~> 0.8"])
  end
end
