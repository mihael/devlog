require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'devlog'

class Test::Unit::TestCase
  include Devlog
end

TEST_FILES_PATH = 'test_devlogs'.freeze
TEMP_PATH = '../tmp'.freeze

def load_devlog
  @tajm = parse_devlog_now(File.join(File.dirname(__FILE__), '..', 'devlog.markdown'))
  puts "#{@tajm.coding_session_time} #{@tajm.com_session_time} #{@tajm.payed_time}"
  assert(@tajm.coding_session_time>0, "truth")
  assert(@tajm.com_session_time>0, "love")
  assert(@tajm.payed_time<0, "simplicity")
end

def load_devlog_now
  @tajm_now = parse_devlog_now(File.join(File.dirname(__FILE__), '..', 'devlog.markdown'))
  puts "#{@tajm_now.coding_session_time} #{@tajm_now.com_session_time} #{@tajm_now.payed_time}"
  assert(@tajm_now.coding_session_time>0, "truth")
  assert(@tajm_now.com_session_time>0, "love")
  assert(@tajm_now.payed_time<0, "simplicity")
end

def load_devlog_test
  @tajm_test = parse_devlog_now(File.join(File.dirname(__FILE__), TEST_FILES_PATH, 'test_devlog.markdown'))
  puts "#{@tajm_test.coding_session_time} #{@tajm_test.com_session_time} #{@tajm_test.payed_time}"
  assert(@tajm_test.coding_session_time>0, "truth")
  assert(@tajm_test.com_session_time>0, "love")
  assert(@tajm_test.payed_time<0, "simplicity")
end

def load_devlog_stat
  @tajm_stat = parse_devlog_now(File.join(File.dirname(__FILE__), TEST_FILES_PATH, 'test_stats_devlog.markdown'))
end

def load_devlog_single
  @tajm_single = parse_devlog_now(File.join(File.dirname(__FILE__), TEST_FILES_PATH, 'test_single_devlog.markdown'))
end

def load_devlog_negative
  @tajm_negative = parse_devlog_now(File.join(File.dirname(__FILE__), TEST_FILES_PATH, 'test_negative_devlog.markdown'))
end
