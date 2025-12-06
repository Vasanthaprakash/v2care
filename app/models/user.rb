# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { patient: "patient", doctor: "doctor", admin: "admin" }

  has_one :doctor
  has_one :patient
end
