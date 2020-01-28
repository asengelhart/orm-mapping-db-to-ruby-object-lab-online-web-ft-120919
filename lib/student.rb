require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    new_id = row[0]
    new_name = row[1]
    new_grade = row[2]
    self.new(new_name, new_grade, new_id)
  end

  def self.map_from_rows(rows)
    rows.map{ |row| new_from_db(row) }
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    all_rows = DB[:conn].execute(sql)
    self.map_from_rows(all_rows)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name)[0]
    new_from_db(row)
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end
  
  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    self.map_from_rows(DB[:conn].execute(sql))
  end

  def self.first_X_students_in_grade_10(limit)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    self.map_from_rows(DB[:conn].execute(sql, limit))
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    all_rows = DB[:conn].execute(sql, grade)
    self.map_from_rows(all_rows)
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
