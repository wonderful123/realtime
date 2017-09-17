class MarketsController < ApplicationController
  def index
    #show available markets
    @platform = Platform.find(params[:platform_id])
    @markets = @platform.markets
    market_list = Market.get_market_summaries
    @markets.each do |market| # remove from list if already added
      market_list.delete_if { |m| m[:market_name] == market.market_name}
    end
    @available_markets = market_list
  end

  def show
    @market = Market.find(params[:id])
  end

  def new
    @market = Market.new
  end

  def create
    @platform = Platform.find(params[:platform_id])
    @market = @platform.markets.create(market_params)
    if @market.save
      redirect_to platform_path(@platform)
    end
  end

  def update
    @market = Market.find(params[:id])
    @market.update_market_summary
    @market.save
    redirect_to @market.platform
  end

  def destroy
    @market = Market.find(params[:id])
    @market.destroy
    redirect_to @market.platform
  end

  private
    def market_params
      params.require(:market).permit(:market_name)
    end
end
