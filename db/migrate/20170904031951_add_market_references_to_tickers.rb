class AddMarketReferencesToTickers < ActiveRecord::Migration[5.1]
  def change
    add_reference :tickers, :market, foreign_key: true
  end
end
