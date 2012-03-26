class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :deafault => false
  end

  def self.down
    remove_column :users, :admin
  end
end
