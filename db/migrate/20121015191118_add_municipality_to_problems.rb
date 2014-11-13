class AddMunicipalityToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :municipality, :string

  end
end
