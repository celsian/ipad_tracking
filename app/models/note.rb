class Note < ActiveRecord::Base
  belongs_to :device
  belongs_to :student
  belongs_to :user

  validates :note, presence: true

  default_scope order("created_at DESC")

  def color
    user_email = User.find(user_id).email
    if user_email == "algarcia@euhsd.net"
      "green"
    elsif user_email == "celsian@gmail.com"
      "blue"
    elsif user_email == "lgarduno@euhsd.net"
      "purple"
    else
      "black"
    end
  end
end
