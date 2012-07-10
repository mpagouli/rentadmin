class AddIndexToModelsGroupsMakes < ActiveRecord::Migration
  def change
  	add_index :models, :model_name, :unique => true
  	add_index :makes, :make_name, :unique => true
  	add_index :groups, :group_name, :unique => true
  end
end
