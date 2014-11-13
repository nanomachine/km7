class AddGmapsToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :gmaps, :boolean

  end
end
