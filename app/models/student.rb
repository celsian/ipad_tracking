class Student < ActiveRecord::Base
  has_many :devices
  has_many :notes
  has_many :finances

  validates :first_name, :last_name, :id_number, :grade_level, :active, presence: true
  validates :id_number, uniqueness: true

  GRADE_LEVEL = [9, 10, 11, 12]
  INSURANCE = ["DLA", "Independent", "None"]

  default_scope { order("last_name, first_name") }

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

  def self.no_devices_search #returns an array of student objects that do not have devices.
    no_devices = []
    Student.all.map do |student|
      if student.devices == []
        no_devices << student
      end
    end
    return no_devices
  end

  def self.import_all(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|

      student = find_by(id_number: row[:id_number]) || Student.new
      parent_1_name = (row[:parent_1_first] || "") + " " + (row[:parent_1_last] || "")
      parent_2_name = (row[:parent_2_first] || "") + " " + (row[:parent_2_last] || "")

      student.attributes = row.to_hash.slice(:id_number, :grade_level, :first_name, :last_name, :email, :home_phone, :current_school, :parent_1_phone, :parent_2_phone,
        :parent_1_email, :parent_2_email, :policy_number, :insurance_expiration)
      student.parent_1_name = parent_1_name
      student.parent_2_name = parent_2_name

      if ["9", "10", "11", "12"].include?(student.grade_level.to_s)
        student.active = true
      else
        student.active = false
      end

      device = Device.find_by(serial_number: row[:serial_number]) || Device.new

      device.attributes = row.to_hash.slice(:device_type, :serial_number, :district_tag)

      if device.save!
        # Note.create(device: device, note: "Device was imported/updated.")
      end

      if student.save
        # Note.create(student: student, note: "Student was imported/updated.")

        if row.to_hash.slice(:note)
          note = Note.new
          note.attributes = row.to_hash.slice(:note)
          note.student = student
          note.save
        end

        if device.save
          device.associate(student, nil)
        end
      end #if student.save

    end #CSV

  end #def end.

  def finance_total
    total = BigDecimal.new(0)
    finances.each do |finance|
      if finance.charge == true
        total -= finance.amount
      else
        total += finance.amount
      end
    end
    total
  end

end
