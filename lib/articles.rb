require "sequel"
require "date"

class Articles
  def all
    db[:articles].all.map do |article|
      time =  article[:time]
      article[:time] = {
        "short" => time.strftime("%Y-%m-%d"),
        "long" => time.strftime("%H:%M - %d %b %Y")
      }
      article
    end
  end

  def save_all(raw_entries)
    entries = raw_entries.map do |entry|
      {
        title: entry[1]["given_title"],
        content: entry[1]["excerpt"],
        link: entry[1]["given_url"],
        time: timestamp(entry[1]["time_added"])
      }
    end
    db[:articles].multi_insert(entries)
  end

  def timestamp(value)
    Time.at(value.to_i).to_datetime
  end

  def db
    Sequel.connect(ENV.fetch("DATABASE_URL"))
  end
end
