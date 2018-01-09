source "https://rubygems.org"

# gemspec # jeweler 2.0.1 adds 'devlog' it self as a dependency for some reason, which results in Travis failing
gem "activesupport", "> 4.1"

group :development, :test do
  gem "test-unit", "~> 3.1"
  gem "jeweler", "~> 2.0"
  gem "nokogiri", "~> 1.8" # jeweler 2.0.1 depends on 1.5.10, but that has sec issue
end