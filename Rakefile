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

task :elm do
  Dir.chdir('pocket_reader_ui') do
    `elm make src/Main.elm --optimize --output=elm.js`
    `uglifyjs elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=elm.min.js`
    `cp elm.min.js ../lib/static/main.js`
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
