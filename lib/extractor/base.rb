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
      match(url) do |attributes|
        record = { }
        attributes.each do |attr|
          label = attr["label"].to_sym

          attr["rules"].each do |rule|
            rule = OpenStruct.new rule

            case rule.type
            when /css/
              doc = Nokogiri::HTML body
              element = doc.css(rule.value).first
              record[label] = element.content.strip if element
            when /regexp/
              pattern = Regexp.new rule.value
              record[label] = $1 if body =~ pattern
            end

            break if record[label]
          end
        end

        record[:url] = url

        yield record
      end
    end

    private 

    def match(url)
      domain_rules = @rules[domain_of(url)]
      domain_rules["ruleSets"].each do |rule_set|
        path_pattern = Regexp.new rule_set["path"]
        if url =~ path_pattern
          yield rule_set["attributes"]
        end
      end if domain_rules
    end

    def domain_of(url)
      uri = URI.parse url
      PublicSuffix.parse(uri.host).domain
    end
  end
end
