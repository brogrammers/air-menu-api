namespace :rake do
  desc "Generate cache to avoid production dependencies on markup languages"
  task :"apipie:cache", :roles => :app do
    run("cd #{current_path}; rake apipie:cache")
  end
end
after "deploy:assets:precompile", "rake:apipie:cache"