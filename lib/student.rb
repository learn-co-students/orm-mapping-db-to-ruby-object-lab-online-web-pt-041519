class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
    select * from students
    SQL
    
    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    select * from students
    SQL
    
    DB[:conn].execute(sql).map do |row|
      if row[1] == name 
        student = Student.new_from_db(row)
      end
      student
    end.first
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
  
  def self.all_students_in_grade_9
    g9 = []
    self.all.map {|student| g9 << student if student.grade == '9'}
    g9
  end
  
  def self.students_below_12th_grade
    arr = []
    self.all.map {|student| arr << student if student.grade != "12"}
    arr
  end
  
  def self.first_X_students_in_grade_10(x)
    arr = []
    i = 0
    g10 = []
    self.all.map {|student| g10 << student if student.grade == '10'}
    until i == x
      arr << g10[i]
      i += 1
    end
    arr
  end
  
  def self.first_student_in_grade_10
    g10 = []
    self.all.map {|student| g10 << student if student.grade == '10'}
    g10[0]
  end
  
  def self.all_students_in_grade_X(x)
    g = []
    self.all.map {|student| g << student if student.grade == x.to_s}
    g
  end
  
end
