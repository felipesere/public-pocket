require "sinatra"
require "sinatra/namespace"
require_relative "articles"

set :public_folder, Proc.new { File.join(root, "static") }

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/assets/:file' do
  send_file File.join(settings.public_folder, params['file'])
end

namespace "/api" do
  before do
    content_type 'application/json'
  end

  get "/articles" do
    Articles.all().to_json
  end
end
