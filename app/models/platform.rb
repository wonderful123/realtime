class Platform < ApplicationRecord
  has_many :markets, dependent: :destroy
  validates :name, presence: true
  accepts_nested_attributes_for :markets

  def self.update_market_summaries(platform_id)
    url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    response = RestClient.get(url)
    parsed_body = JSON.parse(response.body)
    querydata_summaries = parsed_body["result"] if parsed_body["success"]
    querydata_summaries.each do |m|
      @platform = Platform.find(platform_id)
      market = @platform.markets.find_by(market_name: m["MarketName"])
      if market != nil
        market.attributes = {
          high: m["High"],
          low: m["Low"],
          last: m["Last"],
          volume: m["Volume"],
          base_volume: m["BaseVolume"],
          bid: m["Bid"],
          ask: m["Ask"],
          prev_day: m["PrevDay"],
          created: m["Created"],
          open_buy_orders: m["OpenBuyOrders"],
          open_sell_orders: m["OpenSellOrders"]}
        market.save
      end
    end
  end
end
