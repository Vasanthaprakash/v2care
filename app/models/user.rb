# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { patient: "patient", doctor: "doctor", admin: "admin" }

  has_one :doctor
  has_one :patient
  has_many :hospitals, dependent: :destroy


  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= "patient"
  end
end
