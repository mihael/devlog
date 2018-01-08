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
    assert(settings.devlog_file == 'development_log.markdown',
           'example setting should be loaded')
  end

  def test_devlog_file_setting_returns_default_when_overriden_devlog_file_does_not_exist
    assert(devlog_file_setting == 'devlog.markdown',
           'default setting should be returned, since the example setting does not exist')
  end

  def test_nested_settings_are_possible_but_not_encouraged
    assert_raise(NoMethodError) { settings.nested.setting == 'xyz' }
    assert(settings.nested['setting'] == 'xyz', 'xyz should be defined')
  end
end
