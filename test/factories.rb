Factory.define :event do |e|
end

Factory.define :current_event, parent: :event do |ce|
  ce.starts {1.hour.ago}
  ce.ends {1.hour.from_now}
end

Factory.define :photo do |p|
  p.association :event
end

Factory.define :photo_with_device, parent: :photo do |p|
  p.association :device
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