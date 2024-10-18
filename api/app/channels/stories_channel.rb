class StoriesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stories_channel"
  end
end
