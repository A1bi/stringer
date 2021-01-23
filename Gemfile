ruby_version_file = File.expand_path(".ruby-version", __dir__)
ruby File.read(ruby_version_file).chomp if File.readable?(ruby_version_file)
source "https://rubygems.org"

group :production do
  gem "unicorn", "~> 5.3"
end

group :development do
  gem "rubocop", ">= 0.61.1", require: false
end

group :development, :test do
  gem "byebug", "~> 11.1.3"
  gem "faker", "~> 2.15"
  gem "rack-test", "~> 1.1"
  gem "rspec", "~> 3.4"
  gem "rspec-html-matchers", "~> 0.7"
  gem "shotgun", "~> 0.9"
  gem "timecop", "~> 0.8"
end

group :test do
  gem "webmock", "~> 3.11"
end

gem "activerecord", "~> 6.1.1"
gem "bcrypt", "~> 3.1"
gem "delayed_job", "~> 4.1"
gem "delayed_job_active_record", "~> 4.1"
gem "feedbag", "~> 0.10.1"
gem "httparty", "~> 0.17"
gem "i18n"
gem "feedjira", "~> 3.1.2"
gem "loofah", "~> 2.3"
gem "nokogiri", "~> 1.10"
gem "pg", "~> 1.2"
gem "rack-protection", "~> 2.1"
gem "rack-ssl", "~> 1.4"
gem "racksh", "~> 1.0"
gem "rake", "~> 13.0"
gem "sass"
gem "sinatra", "~> 2.1.0"
gem "sinatra-activerecord", "~> 2.0.22"
gem "sinatra-contrib", "~> 2.1.0"
gem "sinatra-flash", "~> 0.3"
gem "sprockets", "~> 4.0.2"
gem "sprockets-helpers"
gem "thread", "~> 0.2"
gem "uglifier"
gem "will_paginate", "~> 3.1"
