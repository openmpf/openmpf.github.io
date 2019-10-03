#! /usr/bin/bash
cd docs && mkdocs build
cd .. && bundle exec jekyll build --config _config.yml,_config_dev.yml
