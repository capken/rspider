# -*- coding: UTF-8 -*-

module WWW
  class Links
    def select(body, pattern)
      doc = Nokogiri::HTML body
      doc.css(pattern).each do |element|
        yield element["href"]
      end
    end
  end
end
