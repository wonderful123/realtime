class CreateTickers < ActiveRecord::Migration[5.1]
  def change
    create_table :tickers do |t|
      t.float :bid
      t.float :ask
      t.float :last

      t.timestamps
    end
  end
end
