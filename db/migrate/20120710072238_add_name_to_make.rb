class AddNameToMake < ActiveRecord::Migration
  def change
    add_column :makes, :name, :string
  end
end
