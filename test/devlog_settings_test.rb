require 'test_helper'

# Test the settings
class DevlogSettingsTest < Test::Unit::TestCase
  def test_settings_default
    assert(Devlog::Settings.debug == false, 'debug should be false')
  end
end
