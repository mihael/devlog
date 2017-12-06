require 'test_helper'

# Test the settings
class DevlogSettingsTest < Test::Unit::TestCase
  def setup
    load_settings(File.join(File.dirname(__FILE__),
                        TEST_FILES_PATH, 'test_settings.yml'))
  end

  def test_settings
    assert(settings.is_a?(Settings) == true, 'settings is a Hash')
  end

  def test_adding_setting
    settings[:new_setting] = 'added'
    assert(settings.new_setting == 'added', 'new_setting should be defined')
  end

  def test_changing_setting_on_the_fly
    settings[:new_setting] = 'added'
    assert(settings.new_setting == 'added', 'new_setting should be defined')
    settings[:new_setting] = 'mod'
    assert(settings.new_setting == 'mod', 'new_setting should be modified')
  end

  def test_loading_from_yaml
    assert(settings.devlog_file == 'devlog.markdown',
           'example_setting should be loaded')
  end
end
