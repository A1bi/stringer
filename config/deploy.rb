# frozen_string_literal: true

lock "~> 3.15"

set :application, "stringer"
set :repo_url, "git@gitlab.a0s.de:albrecht/stringer.git"
set :deploy_to, "/home/stringer/stringer"

append :linked_files, "config/puma.rb", "config/database.yml"
append :linked_dirs, "tmp/cache", "log", ".bundle"

set :keep_releases, 1

set :bundle_without, "development:test:ci"

set :puma_service_name, "stringer_web"
