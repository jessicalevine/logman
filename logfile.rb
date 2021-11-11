require "bundler"
Bundler.require
require "colorize"

class Logfile
  attr_accessor :path
  attr_accessor :parent_session

  def initialize(path, parent_session=nil)
    @path = path
    @parent_session = parent_session
  end

  def pp
    session_str = "(#{parent_session.subfolder_id})".ljust(5).cyan.on_black
    name = File.basename(path, File.extname(path)).ljust(24).capitalize.light_white.on_cyan
    ls = `ls -Clh \"#{path}\"`.split(" ")
    date = "(Date: #{ls[5]} #{ls[6]} #{ls[7]})".ljust(20).cyan.on_black
    size = "(Size: #{ls[4]})".ljust(13).light_white.on_cyan
    "#{session_str} #{name} #{date} #{size} Path: \"#{path}\""
  end

  def to_s
    path
  end
end
