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

set :scm_passphrase, "kesawzejidmaywyot"  # The deploy user's password
default_run_options[:pty] = true

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
    run "cd #{release_path} && RAILS_ENV=production bundle exec rake assets:precompile"
  end
end

after "deploy:restart" do
end

before "deploy:symlink" do
  deploy.precompile
end

require 'bundler/capistrano'
require './config/boot'
