require "sequel"
require "date"

class Metadata 
  def connecting
    Sequel.extension :core_extensions, :pg_array
    Sequel.connect(ENV.fetch("DATABASE_URL")) do |db|
      yield(db)
    end
  end

  def last_successful_time
    connecting do |db|
      db[:meta_data].where(successful: true).order_by(Sequel.desc(:timestamp)).get(:timestamp)
    end
  end

  def append(entry)
    connecting do |db|
      db[:meta_data].insert(entry)
    end
  end
end
