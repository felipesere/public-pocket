require "http"
require "json"

class PocketReader
  def initialize(consumer_key, last_success)
    @consumer_key = consumer_key
    @last_success = last_success
  end

  def read(token, tags)
    response = Http.headers(:content_type => "application/json; charset=utf-8")
                   .post("https://getpocket.com/v3/get", :body => parameters(token, tags).to_json )

    if response.status == 200
      JSON.parse(response.body)
    else
      :error
    end
  end

  def parameters(token, tags)
    {
      "consumer_key" => @consumer_key,
      "detailType" => "complete",
      "access_token" => token,
      "tag" => tags,
      "since" => @last_success.tv_sec
    }
  end
end
