class AddLongMarketNameToMarkets < ActiveRecord::Migration[5.1]
  def change
    add_column :markets, :market_currency_name, :string
  end
end
