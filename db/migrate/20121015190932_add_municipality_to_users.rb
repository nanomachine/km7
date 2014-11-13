class AddMunicipalityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :municipality, :string

  end
end
