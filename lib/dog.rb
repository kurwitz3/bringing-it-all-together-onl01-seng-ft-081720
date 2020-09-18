class Dog 
  
  attr_accessor :name, :breed,:id


 def initialize(id: nil,name:,breed:)
   @name = name 
   @breed = breed 
   @id = id 
 end 
 
 def self.create_table 
   sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT)
   SQL
   DB[:conn].execute(sql)
 end
 
 def self.drop_table
   sql = <<-SQL
    DROP TABLE dogs
   SQL
   DB[:conn].execute(sql)
 end 
 
 def self.new_from_db(array)
   hash = { :id => array[0], :name => array[1], :breed => array[2] }
   self.new(hash)
  end
 
 def save
   sql = <<-SQL
    INSERT INTO dogs (name,breed) Values (?,?)
   SQL
   DB[:conn].execute(sql, self.name, self.breed)

   @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self 
 end 
 def self.create(hash)
   new = self.new(hash)
   new.save
   new
 end 
 def self.find_by_id(id)
      sql = <<-SQL
       SELECT * FROM dogs WHERE id = ?
      SQL
      DB[:conn].execute(sql,id).map do |row|
        self.new_from_db(row)
  end
 end 

 def self.find_by_name(name)
   sql = <<-SQL
   SELECT name FROM dogs 
   SQL
  DB[:conn].execute(sql,name).collect do |row|
    binding.pry 
    self.new_from_db(row)
 
 end
 end
 
 
end 