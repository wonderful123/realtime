class Ticker < ApplicationRecord
  belongs_to :market

  def self.get_latest_ticker(market_name)
    url = "https://bittrex.com/api/v1.1/public/getticker?market=#{market_name}"
    response = RestClient.get(url)
    parsed_body = JSON.parse(response.body)
    querydata = parsed_body["result"] if parsed_body["success"]
    ticker_data = {
      bid: querydata["Bid"],
      ask: querydata["Ask"],
      last: querydata["Last"]}
  end
end
