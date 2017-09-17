class FixColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :markets, :create, :created
  end
end
