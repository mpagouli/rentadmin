class AddAssetIdToAssetCategories < ActiveRecord::Migration
  def change
  	add_column :assets, :asset_category_id, :integer
  end
end
