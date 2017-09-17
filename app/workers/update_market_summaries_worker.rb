class UpdateMarketSummariesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(platform_id)
    Platform.update_market_summaries(platform_id)
  end
end
