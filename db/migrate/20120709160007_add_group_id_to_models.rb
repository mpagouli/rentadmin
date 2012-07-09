class AddGroupIdToModels < ActiveRecord::Migration
  def change
    add_column :models, :model_id, :integer
  end
end
