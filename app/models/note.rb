class Note < ActiveRecord::Base
  belongs_to :device
  belongs_to :student
  belongs_to :user

  validates :note, presence: true

  default_scope order("created_at DESC")
end
