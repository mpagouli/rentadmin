class CreateReservationVehicles < ActiveRecord::Migration
  def change
    create_table :reservation_vehicles do |t|
      t.integer :reservation_id
      t.integer :vehicle_id

      t.timestamps
    end
  end
end
