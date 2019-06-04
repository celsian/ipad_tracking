class Device < ActiveRecord::Base
  belongs_to :student
  has_many :notes

  validates :serial_number, :district_tag, uniqueness: true
  validates :device_type, :serial_number, :district_tag, presence: true

  DEVICES = ["iPad 9.7 6th Gen", "iPad Pro 10.5", "iPad Pro", "iPad Air 2", "iPad Air", "iPad 4", "iPad 3", "MacBook Pro", "MacBook Air"]

  def associate(student, user)
    if self.update_attribute(:student_id, student.id)
      self.checked_in = false
      Note.create(student: student, user: user, device: self, note: "Device was added to student.")
      self.save
    end
  end

  def deassociate(user)
    student = self.student
    if self.update_attribute(:student_id, nil)
      self.checked_in = true
      Note.create(student: student, user: user, device: self, note: "Device was removed from student.")
      self.save
    end
  end

  def self.search query
    query.upcase!
    where("serial_number LIKE :query OR district_tag LIKE :query", query: "%#{query}%")
  end

  def self.export_serial
    CSV.generate do |csv|
      all.each do |device|
        csv << a=[device.serial_number]
      end
    end
  end

  def self.to_csv(options = {})
    unwanted_headers = ["id", "student_id", "created_at", "updated_at"]
    CSV.generate(options) do |csv|
      csv << column_names.delete_if{ |header| unwanted_headers.include?(header) }
      all.each do |device|
        csv << device.attributes.values_at(*column_names)
      end
    end
  end

end



# CODE FOR STUDENT SHOW PAGE REGARDING DEVICE CHECK IN/CHECKOUT
#----------------------------------------------------------------
# <%= form_for @finance do |f| %>
#   <div class="btn-group" data-toggle="buttons-radio">

#     <%= f.radio_button :charge, 'false', id: "Credit", style: "display:none;" %>
#     <label for="Credit" class="btn btn-mini btn-success">Check Out</label>
#   </div>
#   <%= f.text_field :note, placeholder: 'Note', style: 'font-size: 11px; height: 12px; width: 60px; vertical-align: top;' %>
#   <%= f.submit "Go", class: 'btn btn-mini btn-primary'  %>
# <% end %>
