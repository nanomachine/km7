class RemoveUserFromProblems < ActiveRecord::Migration
  def up
  end

  def down
  	remove_column :problems, :user
  end
end
