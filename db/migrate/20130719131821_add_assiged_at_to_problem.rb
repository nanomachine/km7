class AddAssigedAtToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :assigned_at, :datetime
  end
end
