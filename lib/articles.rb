require "sequel"
require "date"

class Articles
  def initialize
    Sequel.extension :core_extensions
    db = Sequel.connect(ENV.fetch("DATABASE_URL"))
    db.extension(:pg_array)
    @db = db
  end

  def all
    @db[:articles].order_by(Sequel.desc(:time)).all.map do |article|
      article[:time] = format(article[:time])
      article
    end
  end

  def format(time)
    {
      "short" => time.strftime("%Y-%m-%d"),
      "long" => time.strftime("%H:%M - %d %b %Y")
    }
  end

  def save_all(raw_entries)
    entries = raw_entries.map { |entry| article(entry) }

    @db[:articles].insert_conflict.multi_insert(entries)
  end

  def article(entry)
      {
        title: entry[1]["given_title"],
        content: entry[1]["excerpt"],
        link: entry[1]["given_url"],
        time: timestamp(entry[1]["time_added"]),
        tags: tags(entry).pg_array
      }
  end

  def tags(entry)
    entry[1]["tags"].keys
  end

  def timestamp(value)
    Time.at(value.to_i).to_datetime
  end
end
