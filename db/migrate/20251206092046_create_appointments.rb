class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.datetime :appointment_time, null: false
      t.string :status, null: false
      t.text :notes

      t.timestamps
    end
  end
end
