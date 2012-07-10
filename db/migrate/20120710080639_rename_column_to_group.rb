class RenameColumnToGroup < ActiveRecord::Migration
  def up
  	remove_column :groups, :name
  	add_column :groups, :group_name, :string
  end

  def down
  	remove_column :groups, :group_name
  	add_column :groups, :name, :string
  end
end
