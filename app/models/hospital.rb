class Hospital < ApplicationRecord
  belongs_to :user  # doctor

  validates :name, :address, :hospital_type, :specialization,
            :opening_time, :closing_time, :slots, presence: true

  validates :slots, numericality: { greater_than: 0 }
end
