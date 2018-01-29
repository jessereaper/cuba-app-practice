=begin
class App
  def layout(page)
    <<~HEREDOC
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>The Simplest Ruby App</title>
          <style type="text/css">
            body{margin:40px auto;max-width:650px;line-height:1.6;font-size:18px;color:#444;padding:0 10px}
            h1,h2,h3{line-height:1.2}
          </style>
        </head>
        <body>
          #{page}
        </body>
      </html>
    HEREDOC
  end

  def call(env)
    status = '200'

    path = env['PATH_INFO'][1..-1]
    filename = if path == ""
                 "index"
               elsif File.file?("views/#{path}.html")
                 path
               else
                 status = "404"
                 "404"
               end
    page = File.read("views/#{filename}.html")

    [
      status,
      {'Content-Type' => 'text/html'},
      [layout(page)]
    ]
  end
end
=end
require "cuba"
require "cuba/safe"
require "cuba/render"
require "erb"
require "sqlite3"

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"] || "__a_very_long_string__"

Cuba.plugin Cuba::Safe
Cuba.plugin Cuba::Render

db = SQLite3::Database.new "./db/dev.db"

Cuba.define do
  on root do
    videogame_array = db.execute("SELECT * FROM videogames")
    videogames = videogame_array.map do |id, name, rating, console|
      { :id => id, :name => name, :rating => rating, :console => console }
    end
    res.write view("index", videogames: videogames)
  end

  on "new" do
    res.write view("new")
  end

  on post do
    on "create" do
      name = req.params["name"]
      rating = req.params["rating"]
      console = req.params["console"]
      db.execute(
        "INSERT INTO videogames (name, rating, console) VALUES (?, ?, ?)",
        name, rating, console
      )
      res.redirect "/"
    end

    on "delete/:id" do |id|
      db.execute(
        "DELETE FROM videogames WHERE id=#{id}"
      )
      res.redirect "/"
    end
  end

  def not_found
    res.status = "404"
    res.headers["Content-Type"] = "text/html"

    res.write view("404")
  end
end
