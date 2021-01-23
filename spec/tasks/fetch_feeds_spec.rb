require "spec_helper"

describe FetchFeeds do
  describe "#fetch_all" do
    let(:feeds) { [FeedFactory.build, FeedFactory.build] }
    let(:fetcher_one) { double }
    let(:fetcher_two) { double }

    it "calls FetchFeed#fetch for every feed" do
      allow(FetchFeed).to receive(:new).and_return(fetcher_one, fetcher_two)

      expect(fetcher_one).to receive(:fetch).once
      expect(fetcher_two).to receive(:fetch).once

      FetchFeeds.new(feeds).fetch_all
    end
  end
end
