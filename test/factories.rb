Factory.define :event do |e|
  e.free true
  e.currency "USD"
  # default PricingTier associated when pricing_tier is nil
end

Factory.define :current_event, parent: :event do |ce|
  ce.starts {1.hour.ago}
  ce.ends {1.hour.from_now}
end

Factory.define :photo do |p|
  p.association :event
  p.association :creator, factory: :user
end

Factory.define :photo_with_device, :class => Photo do |p|
  p.association :event
  p.association :creator, factory: :device
end

Factory.define :processed_photo, parent: :photo do |pp|
  pp.photo_processing nil
end

Factory.define :device do |d|
  d.guid {SecureRandom.hex(16)}
  d.name {Faker::Name.name}
end

Factory.define :user do |u|
  u.email {Faker::Internet.email}
  u.password {SecureRandom.hex(6)}
  u.confirmed_at {DateTime.now}
end

Factory.define :attendee do |a|
  a.association :user
  a.association :event
end

Factory.define :inbound_email do |ie|
  ie.message_id {SecureRandom.hex(6)}
  ie.to          {"#{Factory(:event).code.upcase}@usnap.us"}
end

Factory.define :landing_page do |lp|
  lp.path "test"
  lp.association :pricing_tier
end

Factory.define :billing_detail do |bd|
  bd.association :user
  bd.card_name { Faker::Name.name }
  bd.card_type "Visa"
  bd.month { (Date.today + 1.month).month }
  bd.year { Date.today.year + 1 }
  bd.number "4987654321098769"
  bd.verification_value "123"
  bd.after_create { |b| b.number = nil; b.verification_value = nil }
end

Factory.define :purchase do |pr|
  pr.association :user
  pr.association :event
  pr.amount 123
  pr.currency {PricingTier::CURRENCIES.sample}
end

Factory.define :pricing_tier do |pt|
  pt.price_nzd {rand(10)*100}
  pt.price_usd {rand(10)*100}
end