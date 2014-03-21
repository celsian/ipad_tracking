class Device < ActiveRecord::Base
  belongs_to :student
  has_many :notes

  validates :serial_number, :district_tag, uniqueness: true
  validates :device_type, :serial_number, :district_tag, presence: true

  DEVICES = ["iPad", "MacBook Pro", "MacBook Air"]

  def associate(student, user)
    if self.update_attribute(:student_id, student.id)
      Note.create(student: student, user: user, device: self, note: "Device was added to student.")
    end
  end

  def deassociate(user)
    student = self.student
    if self.update_attribute(:student_id, nil)
      Note.create(student: student, user: user, device: self, note: "Device was removed from student.")
    end
  end

  def self.search query
    query.upcase!
    where("serial_number LIKE :query OR district_tag LIKE :query", query: "%#{query}%")
  end

end