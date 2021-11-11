class Logfile
  attr_accessor :path

  def initialize(path)
    self.path = path
  end

  def to_s
    path
  end
end
