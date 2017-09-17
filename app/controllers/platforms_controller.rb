class PlatformsController < ApplicationController
  def index
    @platforms = Platform.all
  end

  def show
    @platform = Platform.find(params[:id])
  end

  def new
    @platform = Platform.new
  end

  def create
    @platform = Platform.new(platform_params)
    if @platform.save
      redirect_to @platform
    else
      render 'new'
    end
  end

  def update_all_markets
    UpdateMarketSummariesWorker.perform_async(params[:id])
    @platform = Platform.find(params[:id])
    redirect_to @platform
  end

  def destroy
    @platform = Platform.find(params[:id])
    @platform.destroy

    redirect_to platforms_path
  end

  private
    def platform_params
      params.require(:platform).permit(:name, :website)
    end
end
