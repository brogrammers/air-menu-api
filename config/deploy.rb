require 'bundler/capistrano'

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgres"
load "config/recipes/rake"

server 'air-menu.com', :web, :app, :db, primary: true

set :application, 'air-menu-api'
set :user, 'rails-deploy'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, "git@github.com:brogrammers/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"
