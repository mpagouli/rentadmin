class AddGroupIdCToModels < ActiveRecord::Migration
  def change
    add_column :models, :group_id, :integer
  end
end
