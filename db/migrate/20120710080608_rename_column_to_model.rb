class RenameColumnToModel < ActiveRecord::Migration
  def up
  	remove_column :models, :name
  	add_column :models, :model_name, :string
  end

  def down
  	remove_column :models, :model_name
  	add_column :models, :name, :string
  end
end
