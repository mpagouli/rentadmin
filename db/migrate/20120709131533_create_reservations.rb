class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :startDate
      t.datetime :endDate
      t.decimal :duration

      t.timestamps
    end
  end
end
