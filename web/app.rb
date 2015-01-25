require File.expand_path(File.dirname(__FILE__)) + "/../config/load"

require "resque"
require "sinatra"

set :database, {adapter: "sqlite3", database: "db.sqlite3"}

put "/pages/:md5" do
  page = Page.find_by(md5: params[:md5])
  page.update(
    last_cached_at: Time.now,
    status_code: params[:code]
  ) if page

  status page.nil? ? 404 : 200
  json md5: params[:md5]
end

post "/pages/upload" do
  urls = JSON.parse request.body.read.to_s
  urls.each do |url|
    uri = URI.parse url
    md5 = Digest::MD5.hexdigest url

    page = Page.find_by(md5: md5)
    if page.nil?
      page = Page.new do |p|
        p.url = url
        p.md5 = md5
        p.domain = PublicSuffix.parse(uri.host).domain
      end
      page.save
    end

    Resque.enqueue(Spider, {url: page.url, md5: page.md5})
  end

  json totalUrls: urls.size
end
