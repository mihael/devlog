require 'test_helper'

class DevlogTest < Test::Unit::TestCase
  def test_devlog
    t = parse_devlog(File.join(File.dirname(__FILE__), '..', 'devlog.markdown'))
    puts "#{t.coding_session_time} #{t.com_session_time} #{t.payed_time}"
    assert(t.coding_session_time>0, "no time no money no love")
    assert(t.com_session_time>0, "no selftalk")
    assert(t.payed_time<0, "no selfpay")
  end
end
