# frozen_string_literal: true

set :job_template, nil
set :chronic_options, hours24: true
set :environment_variable, "RACK_ENV"

every 15.minutes do
  rake "fetch_feeds"
end
