class ChangeColumnNamesToReservations < ActiveRecord::Migration
  def up
  	remove_column :reservations, :startDate
  	remove_column :reservations, :endDate
  	add_column :reservations, :pick_up_date, :datetime
  	add_column :reservations, :drop_off_date, :datetime
  	add_index :reservations, [:pick_up_date, :drop_off_date]
  	add_index :reservations, :pick_up_date
  	add_index :reservations, :drop_off_date
  end

  def down
  	add_column :reservations, :startDate, :datetime
  	add_column :reservations, :endDate, :datetime
  	remove_column :reservations, :pick_up_date
  	remove_column :reservations, :drop_off_date
  	remove_index :reservations, [:pick_up_date, :drop_off_date]
  	remove_index :reservations, :pick_up_date
  	remove_index :reservations, :drop_off_date
  end
end
