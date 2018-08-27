require_relative 'pocket_reader'
require_relative 'articles'
require_relative 'metadata'

class Pocket
  def self.fetch(tags)
    metadata = Metadata.new

    last_success = metadata.last_successful_time || Time.at(0)
    pocket_reader = PocketReader.new(ENV.fetch("CONSUMER_KEY"), last_success)

    inserted = 0
    access_tokens().each do |token|
      raw_articles = pocket_reader.read(token, tags)['list']
      inserted += raw_articles.count
      Articles.new.save_all(raw_articles)
    end
    metadata.append({successful: true, timestamp: Time.now(), number_of_articles: inserted})
  end

  def self.access_tokens()
    ENV.fetch("ACCESS_TOKEN").split(",")
  end
end
