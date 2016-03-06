#!/bin/bash

step_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

gem install bundler --quiet --silent --no-rdoc --no-ri

(cd $step_dir && bundle install --quiet)
(cd $step_dir && bundle exec ./bin/slack-step)

exit $?
