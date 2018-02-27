xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Liftoff News"
    xml.description "Liftoff to Space Exploration."
    xml.link "http://liftoff.msfc.nasa.gov/"

    @articles.each do |article|
      xml.item do
        xml.title article[:title]
        xml.link article[:link]
        xml.pubDate Time.parse(article[:time]["long"]).rfc822()
        xml.description article[:content]
        xml.guid article[:link]
      end
    end
  end
end
