class AddStatusUpdateColumnToProblems < ActiveRecord::Migration
  def up
    add_column :problems, :status_update, :datetime
  end

  def down
  	remove_column :problems, :status_update, :datetime
  end
end
