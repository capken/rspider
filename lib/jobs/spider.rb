class Spider
  @queue = :spider

  @curl = WWW::Crawler.new
  @cache = CACHE::Base.create(storage: CONFIG[:storage])
  @logger = Logger.new(STDOUT)

  @http = Net::HTTP.new(CONFIG[:server], CONFIG[:port])

  def self.perform(params)
    url, md5 = params["url"], params["md5"]
    @logger.info "Processing #{url}"

    code, header, body = @curl.get(url)
    if code == "200"
      @cache.put(url, body.first, header) 
    else
      @logger.error "Failed to crawl page: #{url}"
    end

    @http.send_request(
      "PUT", "/pages/#{md5}?code=#{code}", "")
  end
end
