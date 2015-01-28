# -*- coding: UTF-8 -*-

module WWW
  class URL

    attr_reader :domain, :md5

    def initialize(url)
      @url = url

      uri = URI.parse url
      @domain = PublicSuffix.parse(uri.host).domain

      @md5 = Digest::MD5.hexdigest url
    end

    def to_s
      @url.to_s
    end

  end
end
