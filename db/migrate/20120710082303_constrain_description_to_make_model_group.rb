class ConstrainDescriptionToMakeModelGroup < ActiveRecord::Migration
   def up
  	remove_column :groups, :description
  	add_column :groups, :description, :string, :limit => 1000
  	remove_column :makes, :description
  	add_column :makes, :description, :string, :limit => 400
  	remove_column :models, :description
  	add_column :models, :description, :string, :limit => 400
  end

  def down
  	remove_column :groups, :description
  	add_column :groups, :description, :string
  	remove_column :makes, :description
  	add_column :makes, :description, :string
  	remove_column :models, :description
  	add_column :models, :description, :string
  end
end
