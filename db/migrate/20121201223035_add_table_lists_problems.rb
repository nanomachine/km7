class AddTableListsProblems < ActiveRecord::Migration
  def up
  	create_table :lists_problems, :id => false do |t|
  		t.references :list
  		t.references :problem
  		t.timestamps
  	end
  end

  def down
  	drop_table :lists_problems
  end
end
