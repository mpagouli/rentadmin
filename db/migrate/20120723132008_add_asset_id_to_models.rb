class AddAssetIdToModels < ActiveRecord::Migration
  def change
  	add_column :assets, :model_id, :integer
  end
end
