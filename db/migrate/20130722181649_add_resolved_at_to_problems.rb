class AddResolvedAtToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :resolved_at, :datetime
    add_column :problems, :resolved_id, :integer
  end
end
