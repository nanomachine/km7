class FixTypeColumnName < ActiveRecord::Migration

  def change
  	rename_column :problems, :type, :ptype
  end

  def up
  end

  def down
  end
end
