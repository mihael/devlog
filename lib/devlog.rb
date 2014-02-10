require "date"
require "active_support/all"
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
module Devlog
  # :stopdoc:
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  VERSION = File.open(File.join(File.dirname(__FILE__), %w[.. VERSION]), 'r') 
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
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
  end
  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, args.flatten)
  end
  # Utility method used to require all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end
  def self.display_version
    "\n#{'Devlog'.green} v#{Devlog.version}\n\n"
  end
  # Write siple console log
  def self.log(txt)
    puts "#{txt}"
  end

  
  def parse_datetime(line)
    parts = line[1..-1].split
    DateTime.strptime("#{parts[0]} #{parts[1]}","%d.%m.%Y %H:%M:%S")
  end

  def parse_devlog_now(devlog=nil)
    t = Parsing.new
    return t unless devlog

    timeEnd = nil
    timeBegin = nil
    in_session = false
    temp_zezzion = nil

    File.open(devlog, "r").each do |line|
      if line =~ /-NOCHARGE/
        in_session = false #do not count nocharge sessions, this is a secret feature
      elsif line =~ /\A#/ && line =~ /CodingSession::END/
        in_session = true
        timeEnd = parse_datetime(line)
        
        #zezzion
        temp_zezzion = Zezzion.new
        temp_zezzion.zzend = timeEnd

      elsif line =~ /\A#/ && line =~ /CodingSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          #cs_time += (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
          delta = (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
          t.coding_session_time += delta

          #zezzion
          temp_zezzion.coding_session_time += delta
          temp_zezzion.zzbegin = timeBegin
          t.add_zezzion temp_zezzion
          temp_zezzion = nil

        end
      elsif line =~ /\A#/ && line =~ /ComSession::END/
        in_session = true
        timeEnd = parse_datetime(line)

        #zezzion
        temp_zezzion = Zezzion.new(Zezzion::COM)
        temp_zezzion.zzend = timeEnd


      elsif line =~ /\A#/ && line =~ /ComSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          delta = (timeEnd - timeBegin).to_f * 24
          t.com_session_time += delta

          #zezzion
          temp_zezzion.coding_session_time += delta
          temp_zezzion.zzbegin = timeBegin
          t.add_zezzion temp_zezzion
          temp_zezzion = nil

        end
      elsif line =~ /\A\+[0-9]+[h]/
        delta = line.to_f
        t.com_session_time += delta

        #zezzion
        if temp_zezzion
          temp_zezzion.com_session_time += delta
        else
          puts "error adding temp_zezzion com_session_time at line: #{line}"  
        end
      elsif line =~ /\A\+[0-9]+[m]/
        delta = (line.to_f / 60)
        t.com_session_time += delta

        #zezzion
        if temp_zezzion
          temp_zezzion.com_session_time += delta
        else
          puts "error adding temp_zezzion com_session_time at line: #{line}"  
        end
      elsif line =~ /\A\-[0-9]+[h]/
        delta = (line.to_f)
        t.payed_time += delta

        #zezzion
        if temp_zezzion
          temp_zezzion.payed_time += delta 
        else
          puts "error adding temp_zezzion delta time at line: #{line}"
        end
      end
        
    end
    #return the Parsing object
    t
  end
  
  def parse_devlog(devlog=nil)
    t = Tajm.new
    return t unless devlog

    timeEnd = nil
    timeBegin = nil
    in_session = false
    
    File.open(devlog, "r").each do |line|
      if line =~ /-NOCHARGE/
        in_session = false #do not count nocharge sessions
      elsif line =~ /\A#/ && line =~ /CodingSession::END/
        in_session = true
        timeEnd = parse_datetime(line)
      elsif line =~ /\A#/ && line =~ /CodingSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          #cs_time += (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
          t.coding_session_time += (timeEnd - timeBegin).to_f * 24 #hours *60 #minutes *60 #seconds
        end
      elsif line =~ /\A#/ && line =~ /ComSession::END/
        in_session = true
        timeEnd = parse_datetime(line)
      elsif line =~ /\A#/ && line =~ /ComSession::BEGIN/
        if in_session
          in_session = false
          timeBegin = parse_datetime(line)
          t.com_session_time += (timeEnd - timeBegin).to_f * 24
        end
      elsif line =~ /\A\+[0-9]+[h]/
        t.com_session_time += line.to_f
      elsif line =~ /\A\+[0-9]+[m]/
        t.com_session_time += (line.to_f / 60)
      elsif line =~ /\A\-[0-9]+[h]/
        t.payed_time += (line.to_f)
      end
        
    end
    #return the Tajm object
    t
  end

  class Parsing
    #this is the total time, but each sessino has these same params
    attr_accessor :coding_session_time, :com_session_time, :payed_time #backward compatible object with Tajm, from devlog 0.0.0

    attr_accessor :zezzions

    def initialize(viewing_time_current_date=DateTime.now)
      @viewing_time_current_date = viewing_time_current_date
      @zezzions = []
 
      #backward compatible object with Tajm, from devlog 0.0.0
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0
     end

    def add_zezzion(zezzion)
      @zezzions << zezzion
    end

    #gloabl devlog start, first entry
    def devlog_begin
      @zezzions.last.zzbegin
    end

    #global devlog end, last entry
    def devlog_end
      @zezzions.first.zzend
    end

    #how much time between first session begin and last session end
    #in seconds
    #def devlog_time
    #  (self.devlog_end.to_time - self.devlog_begin.to_time)/60.0/60.0
    #end

    def session_time
      @zezzions.inject(time=0){|time, zezzion| time+zezzion.session_time}.round(2)
    end

    #how many days devlog spans
    def devlog_days
      count_time(:days=>1)
      #(self.devlog_end - self.devlog_begin).to_i + 1 #counting days like this, would not account for daylight saving changes
    end

    #how many weeks devlog spans
    def devlog_weeks
      (devlog_days/7.0).round(2)
    end

    def devlog_months
      count_time(:months=>1)
    end

    #hours per day
    def per_day      
      (self.session_time/self.devlog_days).round(2)
    end
    def per_week
      (self.session_time/self.devlog_weeks).round(2)
    end
    def per_month
      (self.session_time/self.devlog_months).round(2)
    end

    #total charge time in hours, coding plus communication sessions
    def charge_time
      (coding_session_time + com_session_time).round(2)
    end
    
    #total charge time in hours, coding plus communication sessions - payed hours
    def unpayed_time
      (coding_session_time + com_session_time + payed_time).round(2)
    end

    #return hours worked for the last X days, from beginTime
    def hours_for_last(days, beginTime=DateTime.now)
      endTime = beginTime.to_time - days.days
      selected_zezzions = @zezzions.select{|z| z.zzbegin.to_time<beginTime && z.zzend>=endTime}
      #puts("Selected sessons from #{beginTime} to #{endTime}: #{selected_zezzions.size}")
      selected_zezzions.inject(time=0){|time, z| time+z.session_time}.round(2)
    end

    def longest_session
      @zezzions.max_by(&:session_time)
    end

    def shortest_session
      @zezzions.min_by(&:session_time)
    end

    #return all sessions
    def devlog_sessions
      @zezzions
    end



    private 
      #count :weeks=>1, or :days=>1, or :years=>1
      def count_time(options)
        num = 0
        cur = self.devlog_begin
        while cur < self.devlog_end
          num += 1
          cur = cur.advance(options)
        end
        return num
      end

  end


  class Zezzion
    COM = 1
    COD = 0
    attr_accessor :zzbegin, :zzend, :zzbegin_title, :zzend_title, :zztype
    attr_accessor :coding_session_time, :com_session_time, :payed_time

    def initialize(zztype=COD)
      @zztype = zztype
      @zzbegin = nil
      @zzend = nil
      @zzbegin = nil
      @zzbegin_title = nil
      @zzend_title = nil
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0
    end

    #in seconds
    def time
      @zzend.to_time -  @zzbegin.to_time
    end

    #zezzion_time in days
    def days
      min = self.time / 60
      hours = min / 60
      days = hours / 24
    end

    #the whole coding session time
    def session_time
      @coding_session_time + @com_session_time #in seconds
    end

    #hours per day
    def per_day
      #whole time over number of days the parsing covers      
      session_time/days
    end
    def per_week
      
    end
    def per_month

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