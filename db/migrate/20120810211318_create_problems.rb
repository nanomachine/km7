class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :user
      t.float :lat
      t.float :lng
      t.integer :type
      t.string :description
      t.integer :priority
      t.integer :status

      t.timestamps
    end
  end
end
