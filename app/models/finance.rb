class Finance < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :note, :amount
  validates :amount, numericality: true

  default_scope order("created_at ASC")
  
end
