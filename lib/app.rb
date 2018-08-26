require "sinatra"
require "sinatra/namespace"
require_relative "articles"
require "builder"
require "rack/deflater"

set :public_folder, Proc.new { File.join(root, "static") }

configure do
  enable :cross_origin
  use Rack::Deflater
end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/rss' do
  @articles = Articles.new.all()
  builder :rss
end

get '/assets/:file' do
  send_file File.join(settings.public_folder, params['file'])
end


namespace "/api" do
  before do
    content_type 'application/json'
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get "/articles/:page/:size" do
    page = params[:page].to_i
    size = params[:size].to_i
    articles = Articles.new.paginated(page, size)
    response = {articles: articles}
    if articles.length >= size
      response[:next] = "/api/articles/#{page+1}/#{size}"
    end
    if page > 0
      response[:previous] = "/api/articles/#{page-1}/#{size}"
    end
    response.to_json
  end
end
