Factory.define :event do |e|
end

Factory.define :photo do |p|
  p.association :event
end

Factory.define :device do |d|
  d.guid "ABC123"
end