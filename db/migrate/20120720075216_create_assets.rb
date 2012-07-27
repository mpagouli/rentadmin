class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :filename
      t.string :description

      t.timestamps
    end
  end
end
