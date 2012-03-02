
require 'bundler/capistrano'
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ruby-1.9.2-p180'             # Or whatever env you want it to run in.
set :rvm_bin_path, "/usr/local/rvm/bin"


set :application, "usnapus"

set :user, "deploy"
set :domain, '173.255.217.14'

set :scm, :git
set :repository,  "git@github.com:uSnapUs/#{application}.git"
set :deploy_to, lambda {"/home/#{user}/application"}
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, "production"
set :branch,    "production"
set :normalize_asset_timestamps, false

role :web, domain
role :app, domain
role :db,  domain, :primary=>true

namespace :deploy do
  task :stop do
  end

  task :start do
  end

  task :restart, :roles => [:app], :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_configs do
  end

  task :precompile do
   # run "cd #{release_path} && RAILS_ENV=production bundle install && RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

after "deploy:update_code", "rvm:trust_rvmrc"

after "deploy:restart" do
end
load "deploy/assets"

desc "Hot-reload God configuration for the Resque worker"
deploy.task :reload_god_config do
  run "#{sudo :as => user} god stop resque"
  run "#{sudo :as => user} god load #{File.join deploy_to, 'current', 'config', 'resque.god'}"
  run "#{sudo :as => user} god start resque"
end


# Reload the config file for the resque worker after deploy
after :deploy, 'deploy:reload_god_config'