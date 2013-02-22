class AddNameToProblems < ActiveRecord::Migration
  def up
  	add_column :problems, :title, :string

  end

  def down
  	remove_column :problems, :title, :string

  end
end
