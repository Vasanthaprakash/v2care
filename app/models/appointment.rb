# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :hospital
  belongs_to :user

  enum status: {
    confirmed: "confirmed",
    completed: "completed",
    cancelled: "cancelled"
  }
end
