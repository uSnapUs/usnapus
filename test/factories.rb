Factory.define :event do |e|
end

Factory.define :current_event, parent: :event do |ce|
  ce.starts 1.hour.ago
  ce.ends 1.hour.from_now
end

Factory.define :photo do |p|
  p.association :event
  p.association :device
end

Factory.define :processed_photo, parent: :photo do |pp|
  pp.photo_processing nil
end

Factory.define :device do |d|
  d.guid "ABC123"
  d.name "Nick's iPhone"
end

Factory.define :user do |u|
  u.email { Faker::Internet.email }
  u.password "abc123"
end

Factory.define :billing_detail do |bd|
  bd.association :user
  bd.card_name { Faker::Name.name }
  bd.card_type { ["Visa", "MasterCard"].sample }
  bd.month { (Date.today + 1.month).month }
  bd.year { Date.today.year + 1 }
  bd.number "4111111111111111"
  bd.verification_value "123"
  bd.after_create { |b| b.number = nil; b.verification_code = nil }
end

Factory.define :valid_paypal_billing_detail, parent: :billing_detail do |bd|
  bd.card_type "Visa"
  bd.number "4265251060983807"
  bd.month "4"
  bd.year "2017"
end

Factory.define :invalid_paypal_billing_detail, parent: :valid_paypal_billing_detail do |bd|
  bd.number "4704295276906093"
end