# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: devlog 0.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "devlog".freeze
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["mihael".freeze]
  s.date = "2023-09-25"
  s.description = "devlog.markdown time&space extractor".freeze
  s.email = "kitschmaster@gmail.com".freeze
  s.executables = ["devlog".freeze]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".github/workflows/devlog_test.yml",
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/devlog",
    "devlog.gemspec",
    "devlog.markdown",
    "lib/devlog.rb",
    "lib/devlog_settings.rb",
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
  s.homepage = "http://github.com/mihael/devlog".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.15".freeze
  s.summary = "takes devlog.markdown and gives info".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, ["> 4.1"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.1"])
    s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.8"])
  else
    s.add_dependency(%q<activesupport>.freeze, ["> 4.1"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.1"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.8"])
  end
end

