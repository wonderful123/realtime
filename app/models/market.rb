class Market < ApplicationRecord
  belongs_to :platform
  has_many :tickers, dependent: :destroy
  accepts_nested_attributes_for :tickers
  validates :market_name, presence: true,
                    length: { minimum: 5 }
  after_create :update_market_summary

  def self.get_market_name_long(market_name, getmarkets_querydata)
    #find matching match_name for getmarkets query
    @currency = market_name.split("-")[-1] #default coin name if not available
    getmarkets_querydata.map do |m|
      if market_name == m["MarketName"]
        @currency = m["MarketCurrencyLong"]
      end
    end
    @currency
  end

  def self.percentage_difference(number1, number2)
    (number1 / number2 * 100 - 100).round(2)
  end

  def self.sign(number)
    #return string "positive" or "negative"
    (number < 0) ? "negative" : "positive"
  end

  def update_market_summary
    url = "https://bittrex.com/api/v1.1/public/getmarketsummary?market=#{market_name}"
    response = RestClient.get(url)
    parsed_body = JSON.parse(response.body)
    querydata = parsed_body["result"] if parsed_body["success"]

    # only update long market name the first time
    if !self.attributes.key?(market_currency_name)
      # This query to get long market name
      url = "https://bittrex.com/api/v1.1/public/getmarkets"
      response = RestClient.get(url)
      parsed_body = JSON.parse(response.body)
      querydata_markets = parsed_body["result"] if parsed_body["success"]
      @currency_name = Market.get_market_name_long(market_name, querydata_markets)
    end
    self.attributes = {
      high: querydata[0]["High"],
      low: querydata[0]["Low"],
      last: querydata[0]["Last"],
      volume: querydata[0]["Volume"],
      base_volume: querydata[0]["BaseVolume"],
      bid: querydata[0]["Bid"],
      ask: querydata[0]["Ask"],
      prev_day: querydata[0]["PrevDay"],
      created: querydata[0]["Created"],
      open_buy_orders: querydata[0]["OpenBuyOrders"],
      open_sell_orders: querydata[0]["OpenSellOrders"],
      market_currency_name: @currency_name
    }
  end

  def self.get_market_summaries
    url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    response = RestClient.get(url)
    parsed_body = JSON.parse(response.body)
    querydata_summaries = parsed_body["result"] if parsed_body["success"]

    # This query to get long market name
    url = "https://bittrex.com/api/v1.1/public/getmarkets"
    response = RestClient.get(url)
    parsed_body = JSON.parse(response.body)
    querydata_markets = parsed_body["result"] if parsed_body["success"]

    markets = []
    querydata_summaries.each do |market|
      markets << {
      market_name: market["MarketName"],
      high: market["High"],
      low: market["Low"],
      volume: market["Volume"],
      last: market["Last"],
      base_volume: market["BaseVolume"],
      bid: market["Bid"],
      ask: market["Ask"],
      open_buy_orders: market["OpenBuyOrders"],
      open_sell_orders: market["OpenSellOrders"],
      prev_day: market["PrevDay"],
      created: market["Created"],
      market_currency_name: get_market_name_long(market["MarketName"], querydata_markets),
      change: percentage_difference(market["PrevDay"], market["Last"]),
      change_sign: sign(percentage_difference(market["PrevDay"], market["Last"]))}
    end
    return markets
  end
end
