require "sinatra"
require "sinatra/namespace"

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
    [
      {
      "title" =>  "Generic numeric functions in safe, stable Rust with the num crate",
      "content" => "Note: This post assumes some familiarity with Rust, in particular traits.  It is useful to be able to write code that is generic over multiple types, such as integer types.",
      "time" => {
        "short" => "2017-4-3",
        "long" => "20:38 - 3 Apr 2017"
      },
      "link" => "https://travisf.net/rust-generic-numbers"
    },
    {
      "title" =>  "Advanced Linking",
      "content" => "The common cases of linking with Rust have been covered earlier in this book, but supporting the range of linking possibilities made available by other languages is important for Rust to achieve seamless interaction with native libraries.
",
      "time" => {
        "short" => "2017-3-4",
        "long" => "17:22 - 4 Mar 2017"
      },
      "link" => "https://doc.rust-lang.org/book/advanced-linking.html"
    }
    ].to_json
  end
end
