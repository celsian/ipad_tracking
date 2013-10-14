class Device < ActiveRecord::Base
  belongs_to :student
  has_many :notes, dependent: :destroy

  validates :serial_number, :district_tag, presence: true, uniqueness: true

  DEVICES = ["iPad", "MacBook Pro", "MacBook Air"]

  def associate(student)
    if self.update_attribute(:student_id, student.id)
      Note.create(student: student, device: self, note: "Device was added to student.")
    end
  end

  def deassociate
    student = self.student
    if self.update_attribute(:student_id, nil)
      Note.create(student: student, device: self, note: "Device was removed from student.")
    end
  end

  def self.search query
    query.upcase!
    where("serial_number LIKE :query OR district_tag LIKE :query", query: "%#{query}%")
  end

end