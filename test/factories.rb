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

Factory.define :device do |d|
  d.guid "ABC123"
  d.name "Nick's iPhone"
end