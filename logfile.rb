require "colorize"

require_relative "ndex"

class Logfile
  attr_accessor :path
  attr_accessor :parent_session

  def initialize(path, parent_session=nil)
    @path = path
    @parent_session = parent_session
  end

  def html
    require "nokogiri"
    @html = @html ||  File.open(path) { |f| Nokogiri::HTML(f) } 
  end

  def find_lines(pattern)
    matches = []
    if extension == ".html" || extension == ".htm"
      html.css(Ndex.message_selector).each do |line|
        content = line.content
        matches_content = content.downcase.include?(pattern.downcase) 
        if matches_content and not Ndex.search_exclusions.any? { |e| content.include?(e) }
          matches << content
        end
      end
    elsif extension == ".txt"
      File.open(path, "r") do |file|
        file.each_line do |line|
          matches_line = line.downcase.include?(pattern.downcase) 
          if matches_line and not Ndex.search_exclusions.any? { |e| line.include?(e) }
            matches << line
          end
        end
      end
    else
      puts "Unrecognized filetype for #{path}"
      []
    end

    matches
  end

  def filename
    File.basename(path, File.extname(path))
  end

  def extension
    File.extname(path)
  end

  def match_name?(pattern)
    path.downcase.include?(pattern.downcase)
  end

  def pp
    session_str = "(#{parent_session.subfolder_id})".ljust(5).cyan.on_black
    name = filename.ljust(24).capitalize.light_white.on_cyan
    ls = `ls -Clh \"#{path}\"`.split(" ")
    date = "(Date: #{ls[5]} #{ls[6]} #{ls[7]})".ljust(20).cyan.on_black
    size = "(Size: #{ls[4]})".ljust(13).light_white.on_cyan
    "#{session_str} #{name} #{date} #{size} Path: \"#{path}\""
  end

  def to_s
    path
  end
end
