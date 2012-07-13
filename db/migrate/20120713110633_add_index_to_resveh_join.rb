class AddIndexToResvehJoin < ActiveRecord::Migration
  def change
  	add_index :reservation_vehicles, [:reservation_id, :vehicle_id], :unique => true
  end
end
