# app/models/appointment.rb
class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  enum status: {
    pending: "pending",
    confirmed: "confirmed",
    completed: "completed",
    cancelled: "cancelled"
  }
end
