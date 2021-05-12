#!/usr/bin/env bash
ruby --version
gem --version
bundle --version

bundle exec jekyll build
