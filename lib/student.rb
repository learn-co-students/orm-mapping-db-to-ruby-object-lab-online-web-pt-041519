require 'pry'
class Student
  attr_accessor :id, :name, :grade

  # Create student instance from database row
  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name =  row[1]
    new_student.grade = row[2]
    new_student
  end

  # Get all students from database and create objects for each row
  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
	  SQL
		
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  # Return array of all students in grade 9
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  # Return array of all students below grade 12
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  # Return array of input number of students in grade 10
  def self.first_X_students_in_grade_10(number)
    number = number.to_i
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT #{number}
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }  
  end

  # Return first student in grade 10
  def self.first_student_in_grade_10
    number = number.to_i
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }.first  
  end

  # Return array of students for input grade
  def self.all_students_in_grade_X(grade)
    number = number.to_i
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = #{grade}
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  # Find student in database and create new Student object from matching row
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
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
