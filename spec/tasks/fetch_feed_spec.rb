require "webmock/rspec"

require "spec_helper"
app_require "tasks/fetch_feed"

describe FetchFeed do
  describe "#fetch" do
    subject { FetchFeed.new(feed).fetch }

    let(:feed) do
      FeedFactory.build(url: "http://daringfireball.com/feed",
                        last_fetched: Time.new(2013, 1, 1),
                        stories: [])
    end
    let(:feed_status) { 200 }
    let(:parsed_feed) { double(last_modified: Time.new(2012, 12, 31), entries: []) }

    before do
      allow(StoryRepository).to receive(:add)
      allow(Feedjira).to receive(:parse).with("").and_return(parsed_feed)

      stub_request(:get, feed.url).to_return(status: feed_status)
    end

    context "when feed has not been modified" do
      let(:feed_status) { 304 }

      it "should not try to fetch posts" do
        expect(StoryRepository).not_to receive(:add)
        subject
      end
    end

    context "when no new posts have been added" do
      let(:parsed_feed) { double(last_modified: Time.new(2012, 12, 31)) }

      it "should not add any new posts" do
        allow_any_instance_of(FindNewStories).to receive(:new_stories).and_return([])

        expect { subject }.not_to change(Story, :count)
      end
    end

    context "when new posts have been added" do
      let(:now) { Time.now }
      let(:new_story) { StoryFactory.build }
      let(:old_story) { StoryFactory.build }
      let(:parsed_feed) { double(last_modified: now, entries: [new_story, old_story]) }

      before { allow_any_instance_of(FindNewStories).to receive(:new_stories).and_return([new_story]) }

      it "should only add posts that are new" do
        expect(StoryRepository).to receive(:add).with(new_story, feed)
        expect(StoryRepository).not_to receive(:add).with(old_story, feed)
        subject
      end

      it "should update the last fetched time for the feed" do
        expect { subject }.to change(feed, :last_fetched).to(now)
      end
    end

    context "when feed is not found" do
      let(:feed_status) { 404 }

      it "sets the status to red if things go wrong" do
        expect { subject }.to change(feed, :status).to(:red)
      end
    end

    context "wheen feed is fine" do
      it "sets the status to green if things are all good" do
        expect { subject }.to change(feed, :status).to(:green)
      end
    end
  end
end
