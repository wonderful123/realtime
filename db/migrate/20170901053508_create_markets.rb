class CreateMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :markets do |t|
      t.string :market_name
      t.float :high
      t.float :low
      t.float :volume
      t.float :last
      t.float :base_volume
      t.float :bid
      t.float :ask
      t.integer :open_buy_orders
      t.integer :open_sell_orders
      t.float :prev_day
      t.timestamp :create
      t.references :platform, foreign_key: true

      t.timestamps
    end
  end
end
