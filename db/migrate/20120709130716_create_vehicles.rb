class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :reg_no

      t.timestamps
    end
  end
end
