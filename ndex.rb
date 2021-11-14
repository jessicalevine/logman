require_relative "session"
require "yaml"

NDEX_CONF = ".ndexconf.yml"

module Ndex
  class << self

    attr_accessor :config

    def load
      if File.exists?(NDEX_CONF)
        @config = YAML.load_file(NDEX_CONF)
      else
        puts "No Ndex config file found, please create one at #{NDEX_CONF}, exiting"
        exit
      end
    end

    def plugin_config(plugin, field)
      if config["plugins"] && config["plugins"][plugin]
        config["plugins"][plugin][field]
      else
        puts "Warning: no config found for Ndex plugin \"#{plugin}\""
        nil
      end
    end

    def fulltext_regex_prefix
      config["fulltext_regex_prefix"] || ""
    end

    # Check for the presence of pattern in text, prefixed by the default regex
    # from the conflict file, which can be used to exclude specific sections of
    # the line from the pattern match (for example - don't search the name at
    # beginning of a chat line!)
    def pattern_matches_regex?(text, pattern)
      r = Regexp.new("#{Ndex.fulltext_regex_prefix}(.*#{pattern}.*)", Regexp::IGNORECASE)
      r.match?(text)
    end

    def rootfolder
      config["rootfolder"]
    end

    def subfolder_prefix
      "#{rootfolder}/#{config["subfolder"]}"
    end

    # Nokogiri xpath string for selecting the contents of messages within logs
    def message_selector
      config["search_strings"]["message_selector"]
    end

    # Array of strings to use to exclude bot/system messages when text searching logs
    def search_exclusions
      config["search_strings"]["exclusions"]
    end

    def subfolder_id_from_path(path)
      path.gsub(subfolder_prefix, "").to_i
    end

    def max_id
      sessions.max.subfolder_id
    end

    def min_id
      sessions.min.subfolder_id
    end

    def sessions
      @sessions = @sessions || Dir.glob("#{subfolder_prefix}*").reduce([]) do |ss, path|
        ss << Session.new(path)
      end.sort
    end
  end
end

module NdexPlugin
  Ndex.load

  def ndexable(*fields)
    fields.each do |field|
      body = Proc.new do
        Ndex.plugin_config(self.name.downcase, field.to_s)
      end
      self.send(:define_method, field, body)
    end
  end
end
