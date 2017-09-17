class TickersController < ApplicationController

  def create
    @market = Market.find(params[:market_id])
    @latest_ticker = Ticker.get_latest_ticker(@market.market_name)
    @previous_ticker = @market.tickers.last       #check if there was a ticker to begin with
    if (@previous_ticker == NIL) or
       (@previous_ticker.ask != @latest_ticker[:ask] or #check if new ticker is different
        @previous_ticker.bid != @latest_ticker[:bid] or
        @previous_ticker.last != @latest_ticker[:last])
      @ticker = @market.tickers.create
      @ticker.attributes = {
        ask: @latest_ticker[:ask],
        bid: @latest_ticker[:bid],
        last: @latest_ticker[:last]}
      @ticker.save
      redirect_to @ticker.market
    else
      redirect_to @previous_ticker.market
    end
  end

  def update
     @ticker = @market.tickers.create
  end

  def destroy
    @ticker = Ticker.find(params[:id])
    @ticker.destroy
    redirect_to @ticker.market
  end
end
