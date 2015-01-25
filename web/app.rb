require File.expand_path(File.dirname(__FILE__)) + "/../config/load"

require "resque"
require "sinatra"
require "sinatra/base"
require "sinatra/json"
require "sinatra/activerecord"

require "will_paginate"
require "will_paginate/active_record" 

set :database, {adapter: "sqlite3", database: "db.sqlite3"}

get "/" do
  redirect "index.html"
end

get "/domains" do
  count_by_domain = Page.group(:domain).count
  json count_by_domain.map { |k, v| { name: k, count: v} }
end

get "/pages" do
  page_index = params[:p] || 1
  domain = params[:domain]

  total = Page.where(domain: domain).count

  pages_block = Page.where(domain: domain).
     paginate(per_page: 10, page: page_index)

  json total: total, pages: pages_block
end

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
  #urls = JSON.parse request.body.read.to_s
  urls = request.body.read.to_s.split "\n"
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
