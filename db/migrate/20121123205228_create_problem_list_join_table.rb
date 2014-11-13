	class CreateProblemListJoinTable < ActiveRecord::Migration
 	def change
    	create_table :problems_lists, :id => false do |t|
      	t.integer :problem_id
      	t.integer :list_id
    	end
    	
  	end
end