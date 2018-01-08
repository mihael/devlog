#require "time"
#require "date"
require "active_support/all"
require_relative "./devlog_settings"

# Colors for devlog
class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def dark_green; colorize(self, "\e[32m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def blue; colorize(self, "\e[1m\e[34m"); end
  def dark_blue; colorize(self, "\e[34m"); end
  def pur; colorize(self, "\e[1m\e[35m"); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end

# The devlog module with all the mumbo
module Devlog
  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  VERSION = File.open(File.join(File.dirname(__FILE__), %w[.. VERSION]), 'r').read

  # :startdoc:
  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath(*args)
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path(*args)
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end

  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to(fname, dir = nil)
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
      ::File.join(::File.dirname(fname), dir, '**', '*.rb')
    )

    Dir.glob(search_me).sort.each { |rb| require rb }
  end

  def self.display_version
    "\n#{'Devlog'.green} v#{Devlog.version}\n"
  end

  # Write simple console log
  def self.log(txt)
    puts "#{txt}"
  end

  # Parsing datetime
  DATETIME_FORMAT = '%d.%m.%Y %H:%M:%S'.freeze
  def parse_datetime(line)
    parts = line[1..-1].split
    DateTime.strptime("#{parts[0]} #{parts[1]}", DATETIME_FORMAT)
  rescue StandardError
    abort "\nError\nCan not parse line with invalid date:\n\n#{line}".to_s.blue
  end

  def parse_devlog_now(devlog = nil)
    t = Parsing.new
    t.devlog_file = devlog

    return t unless devlog
    return t unless File.exist?(devlog)

    timeEnd = nil
    timeBegin = nil
    timeEnd_line_number = nil
    timeBegin_line_number = nil
    in_session = false
    temp_zezzion = nil

    line_number = 0
    File.open(devlog, 'r').each do |line|
      line_number += 1

      if line =~ /-NOCHARGE/
        in_session = false # do not count nocharge sessions, this is a secret feature
      elsif line =~ /\A#/ && line =~ /CodingSession::END/
        in_session = true
        timeEnd = parse_datetime(line)
        timeEnd_line_number = line_number

        # zezzion
        temp_zezzion = Zezzion.new
        temp_zezzion.zzend = timeEnd
        temp_zezzion.zzend_line_number = timeEnd_line_number

      elsif line =~ /\A#/ && line =~ /CodingSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          timeBegin_line_number = line_number

          # cs_time += (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
          delta = (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
          t.coding_session_time += delta

          # zezzion
          temp_zezzion.coding_session_time += delta
          temp_zezzion.zzbegin = timeBegin
          temp_zezzion.zzbegin_line_number = timeBegin_line_number
          t.add_zezzion temp_zezzion
          temp_zezzion = nil

        end
      elsif line =~ /\A#/ && line =~ /ComSession::END/
        in_session = true
        timeEnd = parse_datetime(line)
        timeEnd_line_number = line_number

        # zezzion
        temp_zezzion = Zezzion.new(Zezzion::COM)
        temp_zezzion.zzend = timeEnd
        temp_zezzion.zzend_line_number = timeEnd_line_number

      elsif line =~ /\A#/ && line =~ /ComSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          timeBegin_line_number = line_number

          delta = (timeEnd - timeBegin).to_f * 24
          t.com_session_time += delta

          # zezzion
          temp_zezzion.coding_session_time += delta
          temp_zezzion.zzbegin = timeBegin
          temp_zezzion.zzbegin_line_number = timeBegin_line_number
          t.add_zezzion temp_zezzion
          temp_zezzion = nil

        end
      elsif line =~ /\A\+[0-9]+[h]/
        delta = line.to_f
        t.com_session_time += delta

        # zezzion
        if temp_zezzion
          temp_zezzion.com_session_time += delta
        else
          puts "error adding temp_zezzion com_session_time at line: #{line}"
        end
      elsif line =~ /\A\+[0-9]+[m]/
        delta = (line.to_f / 60)
        t.com_session_time += delta

        # zezzion
        if temp_zezzion
          temp_zezzion.com_session_time += delta
        else
          puts "error adding temp_zezzion com_session_time at line: #{line}"
        end
      elsif line =~ /\A\-[0-9]+[h]/
        delta = (line.to_f)
        t.payed_time += delta

        # zezzion
        if temp_zezzion
          temp_zezzion.payed_time += delta
        else
          puts "error adding temp_zezzion delta time at line: #{line}"
        end
      end
    end
    # return the Parsing object
    t
  end

  # Workflow methods

  # Helper for the time entries
  def devlog_session_entry(session_type = 'Coding', begin_end = 'BEGIN')
    "\n##{Time.now.strftime(DATETIME_FORMAT)} #{session_type}Session::#{begin_end}\n"
  end

  # Prepend a string to a text file
  # def prepend_string(t="\n", devlog_file='devlog.markdown')
  #   system "echo '#{t}' | cat - #{devlog_file} > #{devlog_file}.tmp && mv #{devlog_file}.tmp #{devlog_file}"
  # end

  require 'tempfile'
  def prepend_string(path, string = "\n")
    Tempfile.open File.basename(path) do |tempfile|
      tempfile << string
      File.open(path, 'r+') do |file|
        tempfile << file.read
        file.pos = tempfile.pos = 0
        file << tempfile.read
      end
    end
  end

  #insert a new session
  def start_coding_session(devlog_file = 'devlog.markdown')
    prepend_string(devlog_file, devlog_session_entry('Coding', 'BEGIN'))
  end

  #close the current session, if any
  def stop_coding_session(devlog_file = 'devlog.markdown')
    prepend_string(devlog_file, devlog_session_entry('Coding', 'END'))
    save_info(devlog_file)
  end

  def save_info(devlog_file = 'devlog.markdown', info_file = 'info.markdown')
    info = parse_devlog_now(devlog_file)
    if info.has_info?
      File.open(File.join(File.dirname(devlog_file), info_file), 'w') {|f| f.write(info.to_info_string(short=true)) }
    else
      puts "No info present.".red
    end
  end

  def save_to_readme(devlog_file = 'devlog.markdown')
    `cp #{devlog_file} #{File.join(File.dirname(devlog_file), 'README.markdown')}`
  end

  # If the first non empty line is not and END entry then session is open (or malformed file)
  def is_session_open(devlog_file = 'devlog.markdown')
    is_open = true
    File.open(devlog_file, 'r') do |f|
      loop do
        break if not line = f.gets # exit on end of file, read line
        if (line.strip.size>0) # non empty line
          if (line =~ /Session::END/)
            is_open = false
            break
          else
            break
          end
        end
      end
    end
    is_open
  end

  def export_devlog_now(devlog_file = 'devlog.markdown')
    devlog_export_file = File.join(File.dirname(devlog_file), 'devlog_book.markdown')
    # `sed -n '1!G;h;$p' #{devlog_file} > #{devlog_export_file}` #not what we want! , we want just the sessions upside down, but text intact
    # so need to parse all sessions and print them out in reverse!

    sessionEnd = ''
    sessionMidd = ''
    sessionBegin = ''
    in_session = false

    # The ends are the begins, the begins are the ends

    File.new(devlog_export_file, 'wb')

    File.open(devlog_file, 'r').each do |line|
      if line =~ /-NOCHARGE/
        in_session = false #do not export nocharge sessions
      elsif line =~ /\A#/ && (line =~ /CodingSession::END/ || line =~ /ComSession::END/ )
        in_session = true
        sessionEnd = line
      elsif line =~ /\A#/ && ( line =~ /CodingSession::BEGIN/ || line =~ /ComSession::BEGIN/ )
        if in_session
          in_session = false
          sessionBegin = line
          s = sessionBegin + sessionMidd + sessionEnd
          # system "echo '#{s}' | cat - #{devlog_export_file} > #{devlog_export_file}.tmp && mv #{devlog_export_file}.tmp #{devlog_export_file}"
          prepend_string(devlog_export_file, s)
          sessionEnd = ''
          sessionMidd = ''
          sessionBegin = ''
        end
      else
        sessionMidd << line
      end
    end

    devlog_export_file
  end

  # The parsing object
  class Parsing
    # this is the total time, but each session has these same params
    attr_accessor :coding_session_time, :com_session_time, :payed_time #backward compatible object with Tajm, from devlog 0.0.0

    attr_accessor :zezzions, :devlog_file

    def initialize(viewing_time_current_date = DateTime.now)
      @viewing_time_current_date = viewing_time_current_date
      @zezzions = []

      # backward compatible object with Tajm, from devlog 0.0.0
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0

      @devlog_file = ''
    end

    def has_info?
      @zezzions.any?
    end

    def add_zezzion(zezzion)
      @zezzions << zezzion
    end

    # global devlog start, first entry
    def devlog_begin
      @zezzions.last.zzbegin
    end

    # global devlog end, last entry
    def devlog_end
      @zezzions.first.zzend
    end

    # how much time between first session begin and last session end
    # in seconds
    # def devlog_time
    #   (self.devlog_end.to_time - self.devlog_begin.to_time)/60.0/60.0
    # end

    def session_time
      @zezzions.inject(0) { |time, zezzion| time + zezzion.session_time }.round(2)
    end

    # how many days devlog spans
    def devlog_days
      count_time( :days => 1)
      # (self.devlog_end - self.devlog_begin).to_i + 1 #counting days like this, would not account for daylight saving changes
    end

    # how many weeks devlog spans
    def devlog_weeks
      (devlog_days/7.0).round(2)
    end

    def devlog_months
      count_time( :months => 1)
    end

    # hours per day
    def per_day
      (self.session_time/self.devlog_days).round(2)
    end

    def per_week
      (self.session_time/self.devlog_weeks).round(2)
    end

    def per_month
      (self.session_time/self.devlog_months).round(2)
    end

    # total charge time in hours, coding plus communication sessions
    def charge_time
      (coding_session_time + com_session_time).round(2)
    end

    # total charge time in hours, coding plus communication sessions - payed hours
    def unpayed_time
      (coding_session_time + com_session_time + payed_time).round(2)
    end

    # return hours worked for the last X days, from beginTime
    def hours_for_last(days, beginTime = DateTime.now)
      endTime = beginTime.to_time - days.days
      selected_zezzions = @zezzions.select { |z| z.zzbegin.to_time < beginTime && z.zzend >= endTime }
      # puts("Selected sessons from #{beginTime} to #{endTime}: #{selected_zezzions.size}")
      selected_zezzions.inject(0) { |time, z| time + z.session_time }.round(2)
    end

    def longest_session
      @zezzions.max_by(&:session_time)
    end

    def shortest_session
      @zezzions.min_by(&:session_time)
    end

    def negative_sessions
      @zezzions.select{|zezzion| zezzion.session_time<0}
    end

    def zero_sessions
      @zezzions.select{|zezzion| zezzion.session_time==0.0}
    end

    def zero_sessions_to_s
      sessions_to_s(zero_sessions)
    end

    def negative_sessions_to_s
      sessions_to_s(negative_sessions)
    end

    def last_session
      @zezzions.first # devlog_begin
    end

    def first_session
      @zezzions.last # devlog_end
    end

    # return all sessions
    def devlog_sessions
      @zezzions
    end

    def validation_string
      vs = ''
      vs << (@zezzions.any? ? '' : "No sessions recorded, add some first...\n".red)
      vs << (File.exist?(devlog_file) ? '' : "No such file #{devlog_file}...\n".red)
    end

    def to_info_string(short=false)
      s = ''
      s <<  "\nSession::Time:      = #{self.session_time} [h]\n"
      s << ("\nCodingSession::Time = %.1f [h]\n" % self.coding_session_time)
      s << ("\nComSession::Time    = %.1f [h]\n" % self.com_session_time)
      s << ("\nCharge::Time        = #{self.charge_time} [h]\n")
      s << ("\nUnpayed::Time       = #{self.unpayed_time.to_s} [h]\n")
      s << ("\n")
      unless short
        s << ("Num of Sessions     = #{self.devlog_sessions.size}\n")
        s << ("Hours per Day       = #{self.per_day} [h]\n")
        s << ("Hours per Week      = #{self.per_week} [h]\n")
        s << ("Hours per Month     = #{self.per_month} [h]\n")
        s << ("Hours last 7 days   = #{self.hours_for_last(7)} [h]\n")
        s << ("Hours last 14 days  = #{self.hours_for_last(14)} [h]\n")
        s << ("Hours last 28 days  = #{self.hours_for_last(28)} [h]\n")
        s << ("\n")
        s << ("Devlog Time         = #{self.devlog_days * 24} [h]\n")
        s << ("Devlog Days         = #{self.devlog_days}  [days]\n")
        s << ("Devlog Weeks        = #{self.devlog_weeks}  [weeks]\n")
        s << ("Devlog Months       = #{self.devlog_months}  [months]\n")
        if self.negative_sessions.any?
          s << ("\n")
          s << ("#{'Negative Sessions'.red}   = #{self.negative_sessions_to_s}\n")
        end
        if self.zero_sessions.any?
          s << ("\n")
          s << ("#{'Zero Sessions'.blue}       = #{self.zero_sessions_to_s}\n")
        end
        s << ("\n")
        s << ("Longest Session     = #{self.longest_session.to_s}\n")
        s << ("Shortest Session    = #{self.shortest_session.to_s}\n")
        s << ("Last Session        = #{self.devlog_end.ago_in_words}, duration: #{self.last_session.session_time.round(3)} [h]")
      end
      s
    end

    private

      def sessions_to_s(sessions)
        "\n" + sessions.collect{|session| "                      " + session.to_s}.join("\n")
      end

      # count :weeks=>1, or :days=>1, or :years=>1
      def count_time(options)
        num = 0
        cur = self.devlog_begin
        while cur < self.devlog_end
          num += 1
          cur = cur.advance(options)
        end
        num
      end
  end

  class Zezzion
    COM = 1 # communication session
    COD = 0 # coding session
    attr_accessor :zzbegin, :zzend, :zzbegin_title, :zzend_title, :zztype
    attr_accessor :coding_session_time, :com_session_time, :payed_time
    attr_accessor :zzend_line_number, :zzbegin_line_number

    def initialize(zztype = COD)
      @zztype = zztype
      @zzbegin = nil
      @zzend = nil
      @zzbegin = nil
      @zzbegin_title = nil
      @zzend_title = nil
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0
      @zzbegin_line_number = 0
      @zzend_line_number = 0
    end

    # in seconds
    def time
      @zzend.to_time -  @zzbegin.to_time
    end

    # zezzion_time in days
    def days
      min = self.time / 60
      hours = min / 60
      days = hours / 24
    end

    # the whole coding session time
    def session_time
      @coding_session_time + @com_session_time #in seconds
    end

    # hours per day
    def per_day
      # whole time over number of days the parsing covers
      session_time/days
    end
    def per_week
      # todo
    end
    def per_month
      # todo
    end

    def type
      zztype == 0 ? "CodingSession" : "ComSession"
    end

    def to_s
      "#{session_time.round(3)} [h] #{type}, begin on line #{@zzbegin_line_number} at #{@zzbegin}, ends on line #{@zzend_line_number} at #{@zzend}"
    end
  end

  class Tajm
    attr_accessor :coding_session_time, :com_session_time, :payed_time

    def initialize
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0
    end
  end
end

module DateTimeAgoInWords
  def ago_in_words
    return 'a very very long time ago' if self.year < 1800
    secs = Time.now - self
    return 'just over' if secs > -1 && secs < 1
    return 'now' if secs <= -1
    pair = ago_in_words_pair(secs)
    ary = ago_in_words_singularize(pair)
    ary.size == 0 ? '' : ary.join(' and ') << ' ago'
  end
  private
  def ago_in_words_pair(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [100_000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse[0..1]
  end
  def ago_in_words_singularize(pair)
    if pair.size == 1
      pair.map! {|part| part[0, 2].to_i == 1 ? part.chomp('s') : part }
    else
      pair.map! {|part| part[0, 2].to_i == 1 ? part.chomp('s') : part[0, 2].to_i == 0 ? nil : part }
    end
    pair.compact
  end
end

class DateTime
  include DateTimeAgoInWords
end
