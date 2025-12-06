class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :age
      t.string :phone

      t.timestamps
    end
  end
end
