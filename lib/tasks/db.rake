require Rails.root + 'lib/air_menu/database_data'

namespace :db do
  desc "Fill database with base data"
  task :fill => :environment do
    Rake::Task["db:migrate"].invoke
    fill_database
  end

end
