require "webmock/rspec"

require "spec_helper"

app_require "utils/feed_discovery"

describe FeedDiscovery do
  subject { FeedDiscovery.new.discover(url) }

  let(:feed) { double(feed_url: url) }
  let(:url) { "http://example.com" }

  describe "#discover" do
    context "when feed cannot be fetched" do
      let(:invalid_discovered_url) { "http://not-a-valid-feed.com" }
      let(:valid_discovered_url) { "http://a-valid-feed.com" }

      before do
        stub_request(:get, url).to_return(status: 404)
        stub_request(:get, invalid_discovered_url).to_return(status: 404)
        stub_request(:get, valid_discovered_url).to_return(body: "foo")
        allow(Feedbag).to receive(:find).with(url).and_return(found_urls)
        allow(Feedjira).to receive(:parse).with("foo").and_return(feed)
      end

      context "when no other other urls can be found" do
        let(:found_urls) { [] }

        it { is_expected.to be_nil }
      end

      context "when an invalid url is found" do
        let(:found_urls) { [invalid_discovered_url] }

        it { is_expected.to be_nil }
      end

      context "when a valid url is found" do
        let(:found_urls) { [valid_discovered_url] }

        it { is_expected.to eq(feed) }
      end
    end

    context "when feed can be fetched" do
      before do
        stub_request(:get, url).to_return(body: "foo")
        allow(Feedjira).to receive(:parse).with("foo").and_return(feed)
      end

      it { is_expected.to eq(feed) }
    end
  end
end
