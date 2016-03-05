#!/bin/bash

this_dir=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )

bundle install --quiet --gemfile $this_dir/Gemfile
bundle exec $this_dir/bin/slack-step

exit $?
