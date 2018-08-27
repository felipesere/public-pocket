require "sequel"
require "date"

class Articles
  def connecting
    Sequel.extension :core_extensions, :pg_array
    Sequel.connect(ENV.fetch("DATABASE_URL")) do |db|
      yield(db)
    end
  end

  def all
    connecting do |db|
      db[:articles].order_by(Sequel.desc(:time)).all.map do |article|
        article[:time] = format(article[:time])
        article
      end
    end
  end

  def paginated(page, size)
    connecting do |db|
      db[:articles].limit(size, page*size).order_by(Sequel.desc(:time)).map do |article|
        article[:time] = format(article[:time])
        article
      end
    end
  end

  def format(time)
    {
      "short" => time.strftime("%Y-%m-%d"),
      "long" => time.strftime("%H:%M - %d %b %Y")
    }
  end

  def save_all(raw_entries)
    connecting do |db|
      entries = raw_entries.map { |entry| article(entry) }
      db[:articles].insert_conflict.multi_insert(entries, return: :primary_id)
    end
  end

  def article(entry)
      {
        title: entry[1]["resolved_title"],
        content: entry[1]["excerpt"],
        link: entry[1]["resolved_url"],
        time: timestamp(entry[1]["time_added"]),
        tags: tags(entry).pg_array(:text)
      }
  end

  def tags(entry)
    entry[1]["tags"].keys.reject { |k| ["share"].include?(k) }
  end

  def timestamp(value)
    Time.at(value.to_i).to_datetime
  end
end
