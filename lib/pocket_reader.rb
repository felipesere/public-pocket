require "http"
require "json"

class PocketReader
  def initialize(consumer_key)
    @consumer_key = consumer_key
  end

  def read(token)
    response = Http.headers(:content_type => "application/json; charset=utf-8")
                   .post("https://getpocket.com/v3/get", :body => parameters(token).to_json )

    if response.status == 200
      JSON.parse(response.body)
    else
      :error
    end
  end

  def parameters(token)
    {
      "consumer_key" => @consumer_key,
      "detailType" => "complete",
      "access_token" => token,
      "tag" => "share"
    }
  end
end
