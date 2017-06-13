require 'test_helper'

class DevlogTest < Test::Unit::TestCase
  def test_empty_devlog
    @tajm = parse_devlog(File.join(File.dirname(__FILE__), '..', 'empty_devlog.markdown'))
    puts "#{@tajm.coding_session_time} #{@tajm.com_session_time} #{@tajm.payed_time}"
    assert(@tajm.coding_session_time==0, "time is money is love")
    assert(@tajm.com_session_time==0, "selftalk")
    assert(@tajm.payed_time==0, "selfpay")
  end

  def test_devlog_now
    load_devlog
    load_devlog_now

    assert(@tajm.coding_session_time==@tajm_now.coding_session_time, "not equal coding times")
    assert(@tajm.com_session_time==@tajm_now.com_session_time, "selftalk not repeated")
    assert(@tajm.payed_time==@tajm_now.payed_time, "selfpay not equal")

    assert(@tajm_now.zezzions.size>0, "where are the seeds of zezzions?")
    assert(@tajm_now.unpayed_time<0, "let's make sure opensource is free to develop it self")
    assert(@tajm_now.zezzions.size>4, "at least 4 recorded sessions must there be?")
    assert(@tajm_now.devlog_begin.to_s=="2014-01-19T10:16:08+00:00", "a historycal moment in the akashic records was deleted, what?")
    assert(@tajm_now.devlog_begin.to_time.to_i == 1390126568, "or just a random number in a random dream...")
  end

  def test_devlog_test
    load_devlog_test

    assert(@tajm_test.coding_session_time== 4.5, "wrong total coding session time")
    assert(@tajm_test.com_session_time==1.0 , "wrong com session time")
    assert(@tajm_test.payed_time==-1, "wrong payed time")
    assert(@tajm_test.unpayed_time==4.5, "wrong unpayed wrong")
    assert(@tajm_test.charge_time==5.5, "wrong charge wrong")
  end

  def test_devlog_invalid_date
    assert_raise(SystemExit) do
      parse_devlog_now(File.join(File.dirname(__FILE__), '..', 'test_invalid_date_devlog.markdown'))
    end
  end

  def test_p_session_time
    p = Parsing.new
    zezzion = Zezzion.new
    zezzion.zzend = parse_datetime("#08.03.2014 11:00:00 CodingSession::END")
    zezzion.zzbegin = parse_datetime("#08.03.2014 10:00:00 CodingSession::BEGIN")
    zezzion.coding_session_time = 60*60 #1h
    p.add_zezzion zezzion
    zezzion.zzend = parse_datetime("#09.03.2014 11:00:00 CodingSession::END")
    zezzion.zzbegin = parse_datetime("#09.03.2014 10:00:00 CodingSession::BEGIN")
    zezzion.coding_session_time = 60*60 #1h
    p.add_zezzion zezzion

    assert(p.session_time==60*60*2, "should be 7200s but is #{p.session_time}")
  end

  def test_how_much_per_day
    load_devlog_stat
    assert(@tajm_stat.per_day>0, "the middle day value, not the mean")
    assert(@tajm_stat.per_day==1.0, "per day should be 1.0 but is #{@tajm_stat.per_day}")
  end

  def test_how_much_per_week
    load_devlog_stat
    assert(@tajm_stat.per_week>0, "the middle week value, not the mean")
    assert(@tajm_stat.per_week==7.02, "per week should be 7.02 but is #{@tajm_stat.per_week}")
  end

  def test_devlog_weeks
    load_devlog_stat
    assert(@tajm_stat.devlog_weeks==1.14, "devlog weeks should be 1.14 but is #{@tajm_stat.devlog_weeks}")
  end

  def test_how_much_per_month
    load_devlog_stat
    assert(@tajm_stat.per_week>0, "the middle month value, not the mean")
  end

  def test_devlog_days_0
    load_devlog_test
    assert(@tajm_test.devlog_days==33, "should be 33 devlog days")
  end

  def test_devlog_days_1
    load_devlog_stat
    assert(@tajm_stat.devlog_days==8, "should be 8 devlog days")
  end

  def test_devlog_days_2
    load_devlog_single
    assert(@tajm_single.devlog_days==1, "should be 1 devlog day")
  end

  def test_devlog_begin
    load_devlog_stat
    assert(@tajm_stat.devlog_begin.to_s=="2014-03-01T10:00:00+00:00", "devlog begin is wrong")
  end

  def test_devlog_end
    load_devlog_stat
    assert(@tajm_stat.devlog_end.to_s=="2014-03-08T11:00:00+00:00", "devlog end is wrong")
  end

  def test_hours_for_last0
    load_devlog_stat
    hours = @tajm_stat.hours_for_last(0, parse_datetime("#09.03.2014 11:00:00"))
    assert(hours==0, "should be 0, but is #{hours}")
  end
  def test_hours_for_last7
    load_devlog_stat
    hours = @tajm_stat.hours_for_last(7, parse_datetime("#09.03.2014 11:00:00"))
    assert(hours==7, "should be 7, but is #{hours}")
  end
  def test_hours_for_last1
    load_devlog_stat
    hours = @tajm_stat.hours_for_last(1, parse_datetime("#09.03.2014 11:00:00"))
    assert(hours==1, "should be 1, but is #{hours}")
  end

  def test_session_count
    load_devlog_stat
    assert(@tajm_stat.devlog_sessions.size==8, "should be 8, but is #{@tajm_stat.devlog_sessions.size}")
  end

  def test_negative_sessions
    load_devlog_negative
    assert(@tajm_negative.devlog_sessions.size==5, "should be 5, but is #{@tajm_negative.devlog_sessions.size}")
    shortest_session_time_rounded = @tajm_negative.shortest_session.session_time.round(2)
    assert(shortest_session_time_rounded==-2, "should be -2.0, but is #{shortest_session_time_rounded}")
    assert(@tajm_negative.negative_sessions.size==2, "should be 2, but is #{@tajm_negative.negative_sessions.size}")
  end

  def test_zero_sessions
    load_devlog_negative
    assert(@tajm_negative.devlog_sessions.size==5, "should be 5, but is #{@tajm_negative.devlog_sessions.size}")
    zero_session_time_rounded = @tajm_negative.zero_sessions.first.session_time.round(2)
    assert(zero_session_time_rounded==0.0, "should be 0.0, but is #{zero_session_time_rounded}")
    assert(@tajm_negative.zero_sessions.size==1, "should be 1, but is #{@tajm_negative.zero_sessions.size}")
  end

  def test_start_coding_session
    @empty_devlog = File.join(File.dirname(__FILE__), '..', 'tmp1_devlog.markdown')
    File.open(@empty_devlog, 'w') {|f| f.puts('empty')}
    start_coding_session(@empty_devlog)
    assert(File.readlines(@empty_devlog).grep(/CodingSession::BEGIN/).size>0, "should insert CodingSession::BEGIN at top of file")
    assert(is_session_open(@empty_devlog)==true, "should be true, session should be open after starting")
    File.delete(@empty_devlog)
  end

  def test_stop_coding_session
    @empty_devlog = File.join(File.dirname(__FILE__), '..', 'tmp2_devlog.markdown')
    File.delete(@empty_devlog) if File.exist?(@empty_devlog)
    File.open(@empty_devlog, 'w') {|f| f.puts('empty')}
    stop_coding_session(@empty_devlog)
    assert(File.readlines(@empty_devlog).grep(/CodingSession::END/).size>0, "should insert CodingSession::END at top of file")
    assert(is_session_open(@empty_devlog)==false, "should be false, session should be closed after stopping")
    File.delete(@empty_devlog) if File.exist?(@empty_devlog)
  end

  def test_save_info_after_stop_coding_session
    @devlog_info  = File.join(File.dirname(__FILE__), '..', 'info.markdown')
    @empty_devlog = File.join(File.dirname(__FILE__), '..', 'tmp3_devlog.markdown')
    #File.delete(@empty_devlog) if File.exist?(@empty_devlog)
    File.new(@empty_devlog, 'w').puts('\n')
    start_coding_session(@empty_devlog)
    assert(File.readlines(@empty_devlog).grep(/CodingSession::BEGIN/).size>0, "should insert CodingSession::BEGIN at top of file")
    assert(is_session_open(@empty_devlog)==true, "should be true, session should be open after starting")
    prepend_string('+1h', @empty_devlog)
    sleep(1)
    stop_coding_session(@empty_devlog)
    assert(File.readlines(@empty_devlog).grep(/CodingSession::END/).size>0, "should insert CodingSession::END at top of file")
    assert(is_session_open(@empty_devlog)==false, "should be false, session should be closed after stopping")
    assert(File.exists?(@devlog_info)==true, "should exist")
    hasinfo = parse_devlog_now(@empty_devlog).has_info?
    assert(hasinfo==true, 'should have info')
    assert(File.readlines(@devlog_info).grep(/Session::Time/).size>0, "should have info about Session::Time")
    assert(File.readlines(@devlog_info).grep(/Unpayed::Time/).size>0, "should have info about Session::Time")
    assert(File.readlines(@devlog_info).grep(/Num of Sessions/).size==0, "should not include full info")
    File.delete(@empty_devlog) if File.exist?(@empty_devlog)
  end

  def test_is_session_open
    @closed_devlog = File.join(File.dirname(__FILE__), '..', 'test_devlog.markdown')
    assert(is_session_open(@closed_devlog)==false, "should be false, session should be closed")
    @open_devlog = File.join(File.dirname(__FILE__), '..', 'test_open_devlog.markdown')
    assert(is_session_open(@open_devlog)==true, "should be true, session should be open")
  end

  def test_devlog_export
    @exported_devlog = export_devlog_now(File.join(File.dirname(__FILE__), '..', 'test_devlog_export.markdown'))
    assert(File.exists?(@exported_devlog))
    assert(File.size(@exported_devlog)>0, "file should not be empty")
    File.open(@exported_devlog, "r") do |f|
      first = f.readline
      assert(first.blank? == false, "first line isn't blank")
      assert(first =~ /17\.01/, "last line becomes first line in")
      f.readline #empty line
      assert(f.readline =~ /Al/, "should keep text as it was, and in proper session")
      assert(f.readline =~ /Ag/, "should keep text as it was, and in proper session")
      f.readline #empty line
      assert(f.readline =~ /17\.01/, "first line becomes last line")
    end
    File.delete(@exported_devlog) if File.exist?(@exported_devlog)
  end
end
