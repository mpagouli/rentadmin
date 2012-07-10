class RenameColumnToMake < ActiveRecord::Migration
  def up
  	remove_column :makes, :name
  	add_column :makes, :make_name, :string
  end

  def down
  	remove_column :makes, :make_name
  	add_column :makes, :name, :string
  end
end
