class AddModelIdColumnToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :model_id, :integer
  end
end
