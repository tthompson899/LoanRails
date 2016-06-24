class Borrower < ActiveRecord::Base
  has_secure_password
  validates :first_name, :last_name, :email, :purpose, :description, :needed, :purpose, presence: :true
  has_many :histories
  has_many :lenders, through: :histories
end
