require Rails.root + 'lib/air_menu'

namespace :db do
  desc "Fill database with base data"
  task :fill => :environment do
    Rake::Task["db:migrate"].invoke
    task = AirMenu::DatabaseData.new
    task.fill_database
  end

end
