require_relative "logfile"
require_relative "ndex"
require "pathname"

class Session
  include Comparable
  attr_reader :path

  def initialize(path)
   @path = path
  end

  def subfolder_id
    @subfolder_id = @subfolder_id || Ndex.subfolder_id_from_path(path)
  end

  def logfiles
    @logfiles = @logfiles || Dir.glob("#{path}/**/*").reduce([]) do |logs, path|
      # Only add files, not directories
      (Pathname.new(path).file?) ? logs.push(Logfile.new(path, self)) : logs
    end
  end

  def matching_logfiles(pattern)
    logfiles.select do |logfile|
      logfile.match_name?(pattern)
    end
  end

  def to_s
    logfiles.reduce(path) { |str, logfile| str = "#{str}\n\t#{logfile}" }
  end

  def <=>(other)
    self.subfolder_id <=> other.subfolder_id
  end
end
