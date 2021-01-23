require "feedjira"
require "httparty"

require_relative "../repositories/story_repository"
require_relative "../repositories/feed_repository"
require_relative "../commands/feeds/find_new_stories"

class FetchFeed
  def initialize(feed, logger: nil)
    @feed = feed
    @logger = logger
  end

  def fetch
    response = fetch_feed
    case response.code
    when 200
      feed_modified(response)
    when 304
      feed_not_modified
    else
      raise "Feed could not be found (404)."
    end

    FeedRepository.set_status(:green, @feed)
  rescue StandardError => e
    FeedRepository.set_status(:red, @feed)

    @logger.error "Something went wrong when parsing #{@feed.url}: #{e}" if @logger
  end

  private

  def fetch_feed
    HTTParty.get(@feed.url)
  end

  def parse_feed(response)
    Feedjira.parse(response.body)
  end

  def feed_not_modified
    @logger.info "#{@feed.url} has not been modified since last fetch" if @logger
  end

  def feed_modified(response)
    parsed = parse_feed(response)

    new_entries_from(parsed).each do |entry|
      StoryRepository.add(entry, @feed)
    end

    FeedRepository.update_last_fetched(@feed, parsed.last_modified)
  end

  def new_entries_from(parsed)
    finder = FindNewStories.new(parsed, @feed.id, @feed.last_fetched, latest_entry_id)
    finder.new_stories
  end

  def latest_entry_id
    return @feed.stories.first.entry_id unless @feed.stories.empty?
  end
end
