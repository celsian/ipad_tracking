class Note < ActiveRecord::Base
  belongs_to :device
  belongs_to :student
end
