class User < ActiveRecord::Base
  has_many :notes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.disable_all_admins
    User.all.map do |user|
      user.admin = false
      user.save
    end
  end

  def self.update_admins(params, current)
    User.all.map do |user|
      if params[user.id.to_s]
        user.admin = true
        user.save
      end
    end

    user = User.find(current.id)
    user.admin = true
    user.save
  end

end
