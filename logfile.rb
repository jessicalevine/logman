require 'bundler'
Bundler.require
require 'colorize'

class Logfile
  attr_accessor :path
  attr_accessor :parent_session

  def initialize(path, parent_session=nil)
    @path = path
    @parent_session = parent_session
  end

  def pp
    session_str = "(#{parent_session.subfolder_id})".cyan.on_black
    name = File.basename(path, File.extname(path)).capitalize.light_white.on_cyan
    "#{session_str} #{name} \"#{path}\""
  end

  def to_s
    path
  end
end
