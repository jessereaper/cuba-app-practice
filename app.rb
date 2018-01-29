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
    student_array = db.execute("SELECT * FROM students")
    students = student_array.map do |id, name, email, discord|
      { :id => id, :name => name, :email => email, :discord => discord }
    end
    res.write view("index", students: students)
  end

  on "new" do
    res.write view("new")
  end

  on post do
    on "create" do
      name = req.params["name"]
      email = req.params["email"]
      discord = req.params["discord"]
      db.execute(
        "INSERT INTO students (name, email, discord) VALUES (?, ?, ?)",
        name, email, discord
      )
      res.redirect "/"
    end

    on "delete/:id" do |id|
      db.execute(
        "DELETE FROM students WHERE id=#{id}"
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
