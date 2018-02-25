require_relative 'pocket_reader'
require_relative 'articles'

class Pocket
  def self.fetch
    pocket_reader = PocketReader.new(ENV.fetch("CONSUMER_KEY"))
    raw_articles = pocket_reader.read(ENV.fetch("ACCESS_TOKEN"))

    Articles.new.save_all(raw_articles['list'])
  end
end
