class RemoveModelIdFromModels < ActiveRecord::Migration
   def up
  	remove_column :models, :model_id
  end

  def down
  	add_column :models, :model_id, :integer
  end
end
