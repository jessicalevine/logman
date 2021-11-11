require_relative "logfile"
require_relative "ndex"
require "pathname"

class Session
  include Comparable
  attr_accessor :subfolder_id
  attr_accessor :logfiles


  def initialize(subfolder_id)
   @subfolder_id = subfolder_id
   @logfiles = Dir.glob("#{path}/*").reduce([]) do |logs, path|
     # Only add files, not directories
     (Pathname.new(path).file?) ? logs.push(Logfile.new(path, self)) : logs
   end
  end

  def path
    "#{Ndex.subfolder_prefix}#{subfolder_id}"
  end

  def matching_logfiles(pattern)
    logfiles.select do |logfile|
      logfile.path.downcase.include?(pattern.downcase)
    end
  end

  def to_s
    logfiles.reduce(path) { |str, logfile| str = "#{str}\n\t#{logfile}" }
  end

  def <=>(other)
    self.subfolder_id <=> other.subfolder_id
  end
end
