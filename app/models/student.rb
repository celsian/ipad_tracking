class Student < ActiveRecord::Base
  has_many :devices
  has_many :notes
end
