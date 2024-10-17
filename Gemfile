# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in devlog.gemspec
gemspec

gem "rake", "~> 13.0"
gem "activesupport", "> 4.1"

group :development, :test do
  gem "test-unit", "~> 3.1"
  gem "jeweler", "~> 2.0"
  gem "nokogiri", "~> 1.8" # jeweler 2.0.1 depends on 1.5.10, but that has sec issue
end
