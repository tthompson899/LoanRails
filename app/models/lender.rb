class Lender < ActiveRecord::Base
  has_secure_password
  validates :first_name, :last_name, :email, :money, presence: :true

  has_many :histories
  has_many :borrowers, through: :histories
end
