class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.string :type
      t.string :description
      t.decimal :price

      t.timestamps
    end
  end
end
