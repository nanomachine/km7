class RemoveCreatedAtFromListsProblems < ActiveRecord::Migration
  def up
    remove_column :lists_problems, :created_at
    remove_column :lists_problems, :updated_at
  end

  def down
    add_column :lists_problems, :created_at, :datetime
    add_column :lists_problems, :updated_at, :datetime
  end
end
