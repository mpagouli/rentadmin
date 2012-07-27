class AddIndexToAssetName < ActiveRecord::Migration
  def change
  	add_index :assets, :filename, :unique => true
  	add_index :asset_categories, :name, :unique => true
  end
end
