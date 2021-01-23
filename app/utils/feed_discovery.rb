require "feedbag"
require "feedjira"

class FeedDiscovery
  def discover(url)
    feed = get_feed_for_url(url)
    return feed if feed

    urls = Feedbag.find(url)
    return if urls.empty?

    get_feed_for_url(urls.first)
  end

  def get_feed_for_url(url)
    response = HTTParty.get(url)
    raise "Feed could not be fetched" unless response.success?

    feed = Feedjira.parse(response.body)
    feed.feed_url ||= url
    feed
  rescue StandardError
    nil
  end
end
