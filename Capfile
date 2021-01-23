# frozen_string_literal: true

require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/bundler"
require "whenever/capistrano"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
