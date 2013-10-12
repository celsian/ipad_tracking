class Device < ActiveRecord::Base
  belongs_to :student
  has_many :notes, dependent: :destroy

  DEVICES = ["iPad", "MacBook Pro", "MacBook Air"]

  def associate(student)
    self.update_attribute(:student_id, student.id)
  end

  def deassociate
    self.update_attribute(:student_id, nil)
  end

  def self.search query
    query.upcase!
    where("serial_number LIKE :query OR district_tag LIKE :query", query: "%#{query}%")
  end

end