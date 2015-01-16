# -*- coding: UTF-8 -*-

module Extractor
  class Base
    def initialize(opts = {})
      rule_path = File.join CODE_ROOT, "rules", opts[:rule]
      File.open(rule_path, "r") do |file|
        @rule = JSON.parse file.read
      end
    end

    def select(body)
      record = {}

      @rule["attributes"].each do |attr|
        case attr["rule"]["type"]
        when /css/
          doc = Nokogiri::HTML body
          element = doc.css(attr["rule"]["value"]).first
          record[attr["label"]] = element.content.strip if element
        when /regexp/
          pattern = Regexp.new attr["rule"]["value"]
          record[attr["label"]] = $1 if body =~ pattern
        end
      end

      return record
    end
  end
end
