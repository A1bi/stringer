# frozen_string_literal: true

namespace :deploy do
  after :updated, "db:migrate"
end

namespace :db do
  task :migrate do
    on roles(:db) do
      within release_path do
        with rack_env: fetch(:rack_env) do
          execute :rake, "db:migrate"
        end
      end
    end
  end
end
