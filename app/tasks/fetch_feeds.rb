require_relative "fetch_feed"

class FetchFeeds
  def initialize(feeds)
    @feeds = feeds
  end

  def fetch_all
    @feeds.each do |feed|
      thread = Thread.new do
        FetchFeed.new(feed).fetch
      ensure
        ActiveRecord::Base.clear_active_connections!
      end
      thread.join
    end
  end
end
