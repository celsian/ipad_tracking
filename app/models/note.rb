class Note < ActiveRecord::Base
  belongs_to :device
  belongs_to :student

  default_scope order("created_at DESC")
end
