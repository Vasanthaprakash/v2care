class AddCityToHospitals < ActiveRecord::Migration[7.1]
  def change
    add_column :hospitals, :city, :string
  end
end
