#!/bin/bash

this_dir=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

gem install bundler --quiet --no-rdoc --no-ri

bundle install --quiet --gemfile $this_dir/Gemfile
bundle exec $this_dir/bin/slack-step

exit $?
