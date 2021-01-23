require "spec_helper"
require "time"
require "support/active_record"
require "timecop"
require "webmock/rspec"

app_require "tasks/fetch_feed"

describe "Feed importing" do
  def feed_data(path)
    File.new(File.join("spec/sample_data/feeds/#{path}")).read
  end

  subject { fetch_feed.fetch }

  let(:fetch_feed) do
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG
    FetchFeed.new(feed, logger: logger)
  end
  let(:feed) do
    Feed.create(
      name: "Example feed",
      last_fetched: Time.new(2014, 1, 1),
      url: "https://localhost"
    )
  end
  let(:feed_response) { { body: feed_data(feed_data_path) } }

  before { stub_request(:get, feed.url).to_return(feed_response) }

  context "with a valid feed" do
    let(:feed_data_path) { "feed01_valid_feed/feed.xml" }

    before do
      # articles older than 3 days are ignored, so freeze time within
      # applicable range of the stories in the sample feed
      Timecop.freeze Time.parse("2014-08-15T17:30:00Z")
    end

    after { Timecop.return }

    context "when importing once" do
      it "imports all entries" do
        expect { subject }.to change(feed.stories, :count).to(5)
      end
    end

    context "when importing twice" do
      before { fetch_feed.fetch }

      context "with no new entries" do
        it "does not create new stories" do
          expect { subject }.to_not change(feed.stories, :count)
        end
      end

      context "with new entries" do
        let(:feed_data_path2) { "feed01_valid_feed/feed_updated.xml" }
        let(:feed_response) do
          [{ body: feed_data(feed_data_path) },
           { body: feed_data(feed_data_path2) }]
        end

        it "creates new stories" do
          expect { subject }.to change(feed.stories, :count).by(1)
        end
      end
    end
  end

  context "with an invalid feed" do
    let(:feed_data_path) { "feed02_invalid_published_dates/feed.xml" }

    context "when feed has been fetched before" do
      # This spec describes a scenario where the feed is reporting incorrect
      # published dates for stories.
      # The feed in question is feeds.feedburner.com/GiantRobotsSmashingIntoOtherGiantRobots.
      # When an article is published the published date is always set to 00:00 of
      # the day the article was published.
      # This specs shows that with the current behaviour (08-15-2014) Stringer
      # will not detect this article, if the last time this feed was fetched is
      # after 00:00 the day the article was published.

      before { feed.last_fetched = Time.parse("2014-08-12T00:01:00Z") }

      it "imports all new stories" do
        Timecop.freeze Time.parse("2014-08-12T17:30:00Z") do
          expect { subject }.to change { feed.stories.count }.by(1)
        end
      end
    end
  end
end
