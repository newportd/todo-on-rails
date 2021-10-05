# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

server "todo.newport.solutions", port: 22, roles: [:app, :db, :web]
set :application, "todo-on-rails"
set :branch,      "main"
set :repo_url,    "git@github.com:newportd/todo-on-rails.git"

set :user, "todo"

set :puma_access_log,         "/var/log/todo/puma.access.log"
set :puma_bind,               "unix:///run/todo/todo-puma.sock"
set :puma_error_log,          "/var/log/todo/puma.error.log"
set :puma_init_active_record, true
set :puma_pid,                "/run/todo/puma.pid"
set :puma_preload_app,        true
set :puma_state,              "/run/todo/puma.state"
set :puma_threads,            [4, 16]
set :puma_workers,            0
set :puma_worker_timeout,     nil 

set :deploy_to,     "/opt/todo/"
set :deploy_via,    :remote_cache
set :keep_releases, 3
set :pty,           true
set :ssh_options,   { forward_agent: true, user: "root", keys: %w(~/.ssh/root@newport.solutions) }
set :stage,         :production
set :use_sudo,      true

append :linked_files, "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/packs", "public/system"
