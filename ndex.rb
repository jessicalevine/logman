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

    def subfolder_ids
      Dir.glob("#{subfolder_prefix}*").select do |filename|
        filename.include?(subfolder_prefix)
      end.map do |filename|
        filename.gsub(subfolder_prefix, "").to_i
      end
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
