# frozen_string_literal: true

require_relative "lib/devlog/version"

Gem::Specification.new do |spec|
  spec.name = "devlog"
  spec.version = Devlog::VERSION
  spec.authors = ["mihael"]
  spec.email = ["kitschmaster@gmail.com"]

  spec.summary = "Write a development log while also easily track time spent in coding sessions using just a markdown text file and a few CLI commands."
  spec.description = "devlog.markdown time&space extractor ~ Track the time spent in coding sessions while also writing a development log. Export a timesheet for your bills."
  spec.homepage = "https://manitu.si/devlog"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mihael/devlog"
  spec.metadata["changelog_uri"] = "https://github.com/mihael/devlog/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # gemspec = File.basename(__FILE__)
  # spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
  #   ls.readlines("\x0", chomp: true).reject do |f|
  #     (f == gemspec) ||
  #       f.start_with?(*%w[bin/ lib/ sublime_text/ templates/ test/ .git .github .gitignore .ruby-gemset .ruby-version devlog.gemspec devlog.markdown Gemfile LICENSE.txt CHANGELOG.md README.md Rakefile tmp/.gitignore])
  #   end
  # end
  spec.files = [
    ".github/workflows/devlog_test.yml",
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "CHANGELOG.md",
    "Rakefile",
    "bin/console",
    "bin/setup",
    "exe/devlog",
    "devlog.gemspec",
    "devlog.markdown",
    "lib/devlog.rb",
    "lib/devlog/utils.rb",
    "lib/devlog/settings.rb",
    "lib/devlog/version.rb",
    "sublime_text/devlog.tmbundle/Snippets/begin.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/combegin.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/comend.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/end.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/link.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/selfbegin.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/selfend.tmSnippet",
    "sublime_text/devlog.tmbundle/Snippets/tu.tmSnippet",
    "sublime_text/devlog.tmbundle/info.plist",
    "sublime_text/tu.py",
    "templates/background.jpg",
    "templates/weekly_timesheet.erb.html",
    "test/devlog_file_test.rb",
    "test/devlog_settings_test.rb",
    "test/devlog_test.rb",
    "test/test_devlogs/.devlog.yml",
    "test/test_devlogs/empty_devlog.markdown",
    "test/test_devlogs/test_devlog.markdown",
    "test/test_devlogs/test_devlog_export.markdown",
    "test/test_devlogs/test_invalid_date_devlog.markdown",
    "test/test_devlogs/test_negative_devlog.markdown",
    "test/test_devlogs/test_open_devlog.markdown",
    "test/test_devlogs/test_settings.yml",
    "test/test_devlogs/test_single_devlog.markdown",
    "test/test_devlogs/test_stats_devlog.markdown",
    "test/test_devlogs/test_weekly_devlog.markdown",
    "test/test_helper.rb",
    "tmp/.gitignore"
  ]

  spec.bindir = "exe"
  spec.executables = ["devlog"]
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "activesupport"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "nokogiri"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
