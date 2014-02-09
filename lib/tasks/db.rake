require Rails.root + 'lib/air_menu/database_data'

namespace :db do
  desc "Fill database with base data"
  task :fill => :environment do
    fill_scopes
    fill_oauth_applications
    fill_users
    fill_restaurants
  end

end
