class AddIndexToProblemIdAndListId < ActiveRecord::Migration
  def change
  	add_index :problems_lists, :problem_id
  	add_index :problems_lists, :list_id
  end
end
