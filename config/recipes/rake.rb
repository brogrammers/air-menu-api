namespace :rake do
  desc "Generate cache to avoid production dependencies on markup languages"
  task :"apipie", :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake apipie:cache"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake apipie:static"
  end
end
after "deploy:create_symlink", "rake:apipie"