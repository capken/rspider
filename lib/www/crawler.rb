# -*- coding: UTF-8 -*-

module WWW
  class Crawler

    USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Firefox/17.0"
    PRIVOXY_URL = "127.0.0.1:8118"

    class RetryException < StandardError; end

    def initialize(opts = {})
      @curl = Curl::Easy.new do |c|
        c.follow_location = true
        c.max_redirects = 3
        c.timeout = 8
        c.connect_timeout = 5
        c.headers["User-Agent"] = USER_AGENT
        c.encoding = 'gzip,deflate'
        c.proxy_url = PRIVOXY_URL if opts[:proxy]
      end
    end

    def get(url)
      request(url) do |curl|
        curl.perform
        case curl.response_code
        when 200
          ['200', {'content-type' => curl.content_type }, [curl.body_str]]
        else
          raise RetryException
        end
      end
    end

    def request(url)
      retries = 0
      begin
        @curl.url = url.to_s
        yield @curl
      rescue RetryException => e
        code = @curl.response_code
        retries += 1
        retry if retries < 3
        [code.to_s, {}, ['Retry Failure']]
      rescue => e
        ['777', {}, [ e.message ]]
      end
    end
  end
end
