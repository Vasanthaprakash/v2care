class CreateHospitals < ActiveRecord::Migration[7.1]
  def change
    create_table :hospitals do |t|
      t.string :name
      t.text :address
      t.string :hospital_type
      t.string :specialization
      t.time :opening_time
      t.time :closing_time
      t.integer :slots
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
