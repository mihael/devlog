require 'yaml'
require 'ostruct'
#require 'pry'

#
module Devlog
  # Settings - keep it simple: lower_case: one_level_only
  # Allow settings.key besides settings[:key]
  # If the method name exists as a key within this Hash, fetch it.
  class Settings < Hash
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
    @settings = Settings[YAML.load_file(file)]
  rescue
    # Please add devlog.yml to configure.
  end

  def settings
    @settings
  end
end
