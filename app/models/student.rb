class Student < ActiveRecord::Base
  has_many :devices
  has_many :notes

  validates :first_name, :last_name, :id_number, :grade_level, :active, presence: true
  validates :id_number, uniqueness: true

  GRADE_LEVEL = [9, 10, 11, 12]

  default_scope order("last_name, first_name")

  def title_case
    if self.first_name != "" && self.last_name != ""
      self.first_name.downcase!
      self.last_name.downcase!

      f = first_name[0].upcase
      l = last_name[0].upcase
      self.first_name = f + self.first_name[1..-1]
      self.last_name = l + self.last_name[1..-1]
    end
  end

  def self.title_case_query query
    if query != ""
      query = query.downcase
      query = query[0].upcase + query[1..-1]
    else
      return nil
    end
  end

  def self.search query
    query = Student.title_case_query(query)
    where("first_name LIKE :query OR last_name LIKE :query OR id_number LIKE :query", query: "%#{query}%")
  end

  def self.import_all(file)
    CSV.foreach(file.path, headers: true) do |row|
      student = find_by(id_number: row["id_number"]) || Student.new
      student.attributes = row.to_hash.slice("id_number", "grade_level", "first_name", "last_name")

      device = Device.find_by(serial_number: row["serial_number"]) || Device.new
      device.attributes = row.to_hash.slice("device_type", "serial_number", "district_tag")
      binding.pry
      
      if device.save
        Note.create(device: device, note: "Device was imported/updated.")
      end

      if student.save
        Note.create(student: student, note: "Student was imported/updated.")
        device.associate(student)
      end
    end
  end

end
