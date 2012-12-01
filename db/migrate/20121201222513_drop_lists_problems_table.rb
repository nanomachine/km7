class DropListsProblemsTable < ActiveRecord::Migration
  def up
  	drop_table :lists_problems
  end

  def down
  end
end
