require 'pg'
require 'pry'
require 'csv'

def db_connection
  begin
    connection = PG.connect(dbname: "ingredient_list")
    yield (connection)
  ensure
    connection.close
  end
end

CSV.foreach("ingredients.csv") do |row|
  db_connection do |conn|
    conn.exec_params("INSERT INTO ingredients (name) VALUES ($1)", [row[1]])
  end
end

ingredients = ((db_connection { |conn| conn.exec("SELECT name FROM ingredients") }).to_a).uniq
ingredients.each_index do |index|
  puts "#{index+1}: #{ingredients[index]["name"]}"
end
