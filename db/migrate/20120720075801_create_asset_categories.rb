class CreateAssetCategories < ActiveRecord::Migration
  def change
    create_table :asset_categories do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
