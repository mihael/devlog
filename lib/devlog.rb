require "date"
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
    
  class Tajm
    attr_accessor :coding_session_time, :com_session_time, :payed_time
    def initialize
      @coding_session_time = 0.0
      @com_session_time = 0.0
      @payed_time = 0.0
    end
  end
  
  def parse_datetime(line)
    parts = line[1..-1].split
    DateTime.strptime("#{parts[0]} #{parts[1]}","%d.%m.%Y %H:%M:%S")
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
    #return the T object
    t
  end
  
end