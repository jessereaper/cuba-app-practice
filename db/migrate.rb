File.delete("./db/dev.db") if File.file?("./db/dev.db")

require_relative "migrations/1_create_students_table"

puts "Success!"
