# -*- coding: UTF-8 -*-

module Extractor
  class Base

    def initialize(opts = {})
      @rules = {}

      rules_path = File.join CODE_ROOT, "rules/*.json"
      Dir.glob(rules_path).each do |rule_path|
        File.open(rule_path, "r") do |file|
          rule = OpenStruct.new JSON[file.read]
          @rules[rule.domain] = rule
        end
      end
    end

    def select(url, body)
      rule = @rules[domain_of(url)]

      record = {}
      rule.attributes.each do |attr|
        label = attr["label"]
        rule = OpenStruct.new attr["rule"]

        case rule.type
        when /css/
          doc = Nokogiri::HTML body
          element = doc.css(rule.value).first
          record[label] = element.content.strip if element
        when /regexp/
          pattern = Regexp.new rule.value
          record[label] = $1 if body =~ pattern
        end
      end if rule

      return record
    end

    private 

    def domain_of(url)
      uri = URI.parse url
      PublicSuffix.parse(uri.host).domain
    end
  end
end
