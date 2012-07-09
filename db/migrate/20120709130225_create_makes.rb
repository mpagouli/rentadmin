class CreateMakes < ActiveRecord::Migration
  def change
    create_table :makes do |t|
      t.string :description

      t.timestamps
    end
  end
end
