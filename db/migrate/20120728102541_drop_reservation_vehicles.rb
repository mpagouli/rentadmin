class DropReservationVehicles < ActiveRecord::Migration
  def up
  	drop_table :reservation_vehicles
  end

  def down
  	create_table :reservation_vehicles do |t|
      t.integer :reservation_id
      t.integer :vehicle_id
      t.timestamps
  	end
  end
end
