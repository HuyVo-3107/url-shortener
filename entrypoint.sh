#!/bin/bash
set -e

# Bundle
bundle install

# Remove a potentially pre-existing server.pid for Rails.
rm -f /home/app/tmp/pids/server.pid

#setup db
#db:prepare will run db:migrate. If db:migrate fails, then db:create, db:seed, followed by db:migrate are run.
rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
