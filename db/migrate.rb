=begin
require "sqlite3"

File.delete("./dev.db") if File.file?("./dev.db")

require_relative "migrations/1_create_videogame_table"
=end

File.delete("./db/dev.db") if File.file?("./db/dev.db")

require_relative "migrations/1_create_videogames_table"

puts "Success!"
