class AddUniqueIndexForListsProblems < ActiveRecord::Migration
  def up
  	add_index :lists_problems, [ :list_id, :problem_id ], :unique => true, :name => 'by_list_and_problem'
  end

  def down
  	remove_index :lists_problems, [ :list_id, :problem_id ], :unique => true, :name => 'by_list_and_problem'
  end
end
