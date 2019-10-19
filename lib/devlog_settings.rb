require 'yaml'
require 'ostruct'
# require 'pry'

#
module Devlog
  # Settings - keeping it simple.
  # Allow settings.key besides settings[:key]
  # If the method name exists as a key within this Hash, fetch it.
  class Settings < Hash
    def has?(m)
      return key?(m) || key?(m.to_s)
    end

    def method_missing(m, *args, &block)
      if key?(m)
        fetch m
      elsif key?(m.to_s)
        fetch m.to_s
      else
        super
      end
    end
  end

  def load_settings(file)
    begin
      yaml = YAML.load_file(file)
    rescue
      yaml = nil
    end
    @settings = yaml ? Settings[yaml] : Settings.new
  end

  def settings
    @settings ||= Settings.new
  end

  # The default is the current folder with devlog.markdown in it.
  DEVLOG_FILE = 'devlog.markdown'.freeze

  # Calculate a devlog_file path.
  def devlog_file_setting
    return DEVLOG_FILE unless settings
    devlog_file_setting = settings['devlog_file']
    if devlog_file_setting && File.exist?(File.join(Dir.pwd, devlog_file_setting))
      devlog_file_setting
    else
      DEVLOG_FILE
    end
  end
end
