class Logfile
  attr_accessor :path
  attr_accessor :parent_session

  def initialize(path, parent_session=nil)
    @path = path
    @parent_session = parent_session
  end

  def to_s
    path
  end
end
