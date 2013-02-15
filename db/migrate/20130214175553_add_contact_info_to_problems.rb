class AddContactInfoToProblems < ActiveRecord::Migration
  def up
    add_column :problems, :c_name, :string
    add_column :problems, :c_telnum, :string
    add_column :problems, :c_email, :string
  end

  def down
  	remove_column :problems, :c_name, :string
    remove_column :problems, :c_telnum, :string
    remove_column :problems, :c_email, :string
  end
end
