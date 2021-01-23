require "rubygems"
require "bundler"

Bundler.require(:default, ENV.fetch("RACK_ENV", "development"))

require "./fever_api"
map "/fever" do
  run FeverAPI::Endpoint
end

require "./app"
run Stringer
