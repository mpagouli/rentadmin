class AddIdentityNumberToClients < ActiveRecord::Migration
  def change
  	add_column :clients, :identity_number, :string
  	add_index :clients, :identity_number, :unique => true
  end
end
