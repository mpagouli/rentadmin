class AddColumnsAndIndexesToReservations < ActiveRecord::Migration
  def change
  	add_column :reservations, :vehicle_id, :integer
  	add_column :reservations, :client_id, :integer
  	add_column :reservations, :reservation_code, :string
  	add_index :reservations, :reservation_code, :unique => true
  end
end
