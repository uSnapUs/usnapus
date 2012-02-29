require 'resque'
Resque.redis.namespace = "resque:uSnapUs"
require 'resque/server'
Resque::Server.use Rack::Auth::Basic do |username, password|
  username == "snapadmin"
  password == "tip7bieb2ic2hav3i5og"
end