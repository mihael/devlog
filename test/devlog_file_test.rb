require 'test_helper'

# Test the devlog_file_setting override
class DevlogFileTest < Test::Unit::TestCase
  def setup
    load_settings(File.join(File.dirname(__FILE__),
                        TEST_FILES_PATH, '.devlog.yml'))
  end

  def test_devlog_file_returns_the_overriden_devlog_file
    x = "overridden setting should be returned, but was #{devlog_file_setting}"
    assert(devlog_file_setting == 'test/test_devlogs/test_devlog.markdown', x)
  end
end
