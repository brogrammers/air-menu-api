# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'air-menu-api'
set :repo_url, "git@github.com:brogrammers/#{fetch(:application)}.git"
set :deploy_user, 'rails-deploy'
set :user, 'rails-deploy'

set :config, {
    :nginx => 'nginx.conf',
    :init => 'init.sh',
    :unicorn => 'unicorn.rb',
    :postgres => 'postgres.yml'
}

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true
set :use_sudo, false

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do



end

after 'nginx:setup', 'nginx:restart'
after 'deploy:setup', 'nginx:setup'
after 'deploy:finished', 'unicorn:restart'
after 'deploy:setup', 'unicorn:setup'
after 'deploy:setup', 'postgresql:setup'
after 'deploy:migrate', 'postgresql:fill'
before 'deploy:compile_assets', 'postgresql:symlink'
after 'deploy:migrate', 'rake_stuff:apipie'