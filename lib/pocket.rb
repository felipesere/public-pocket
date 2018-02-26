require_relative 'pocket_reader'
require_relative 'articles'

class Pocket
  def self.fetch
    pocket_reader = PocketReader.new(ENV.fetch("CONSUMER_KEY"))

    access_tokens().each do |token|
      raw_articles = pocket_reader.read(token)
      Articles.new.save_all(raw_articles['list'])
    end
  end

  def self.access_tokens()
    ENV.fetch("ACCESS_TOKEN").split(",")
  end
end
