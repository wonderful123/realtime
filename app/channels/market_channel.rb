class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "market_channel" # _#{room.id}
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_market
    ####
  end
end
