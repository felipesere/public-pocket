task :default do
  system "rake --tasks"
end

namespace :server do
  desc "Running the server"

  task :tunnel do
    system "ngrok http -subdomain=publicpocket 4567"
  end

  task :run do
    system "rerun 'ruby lib/app.rb'"
  end
end

# DB migrations
namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end

namespace :pocket do
  desc "Fetch shared articles from Pocket API"
  task :fetch do |t, args|
    require "sequel"
    require_relative 'lib/pocket.rb'

    Pocket.fetch("share")
  end
end
