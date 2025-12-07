class UpdateAppointmentsWithUserAndHospital < ActiveRecord::Migration[7.1]
  def change
    # Remove old columns
    remove_column :appointments, :doctor_id, :integer
    remove_column :appointments, :patient_id, :integer

    # Add new columns
    add_column :appointments, :user_id, :integer
    add_column :appointments, :hospital_id, :integer

    # Add indexes
    add_index :appointments, :user_id
    add_index :appointments, :hospital_id
  end
end
