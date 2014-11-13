class AddAddressToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :address, :string

  end
end
