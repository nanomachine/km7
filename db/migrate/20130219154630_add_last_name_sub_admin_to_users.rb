class AddLastNameSubAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_name, :string
    add_column :users, :sub_admin, :boolean

  end

  def self.down
    remove_column :users, :sub_admin, :boolean
  end
end
