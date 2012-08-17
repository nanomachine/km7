class FixCoordinateColumnNames < ActiveRecord::Migration
  def up
  end

  def down
  end

  def change
  	rename_column :problems, :lat, :latitude
  	rename_column :problems, :lng, :longitude
  end
end
