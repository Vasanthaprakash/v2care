class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :specialization
      t.string :clinic_name

      t.timestamps
    end
  end
end
