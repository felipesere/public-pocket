require "sequel"

class Articles
  def all
    db[:articles].all
  end

  def save_all(raw_entries)
    entries = raw_entries.map do |entry|
      {
        title: entry[1]["given_title"],
        content: entry[1]["excerpt"],
        link: entry[1]["given_url"],
        time: entry[1]["time_added"].to_i
      }
    end
    db[:articles].multi_insert(entries)
  end

  def db
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end
end
