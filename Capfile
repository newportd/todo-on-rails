# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# scm
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# rails
require "capistrano/rails"

# bundler
require "capistrano/bundler"

# puma
require "capistrano/puma"
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
