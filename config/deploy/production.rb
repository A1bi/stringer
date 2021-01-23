# frozen_string_literal: true

set :rack_env, :production

server "stringer.a0s.de", user: "stringer", roles: %w[app db web]
