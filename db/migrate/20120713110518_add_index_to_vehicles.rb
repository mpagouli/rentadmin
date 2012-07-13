class AddIndexToVehicles < ActiveRecord::Migration
  def change
  	add_index :vehicles, :reg_no, :unique => true
  end
end
