require "sqlite3"

db = SQLite3::Database.new "./db/dev.db"

db.execute "
  create table students (
    id INTEGER PRIMARY KEY ASC,
    name VARCHAR(255),
    email VARCHAR(255),
    discord VARCHAR(255)
  );
"

students = [
  ["Chad Ostrowski", "ostrowski@stevens.edu", "ProfessorO"],
]

students.each do |student|
  db.execute(
    "INSERT INTO students (name, email, discord) VALUES (?, ?, ?)", student
  )
end
