require File.expand_path(File.dirname(__FILE__)) + "/../config/load"

require "resque"
require "sinatra"
require "sinatra/base"
require "sinatra/json"
require "sinatra/activerecord"

require "will_paginate"
require "will_paginate/active_record" 

set :cache, CACHE::Base.create(storage: CONFIG[:storage])
set :extractor, Extractor::Base.new

set :database, { 
  adapter: CONFIG[:adapter],
  database: CONFIG[:database]
}

#get "/" do
#  redirect "index.html"
#end

get "/domains" do
  count_by_domain = Page.group(:domain).count
  json count_by_domain.map { |k, v| { name: k, count: v} }
end

get "/pages/statistic" do
  count_by_status = Page.where(domain: params[:domain]).
    group(:status_code).count
  json count_by_status.map { |k,v| { status: k, count: v} }
end

get "/pages" do
  page_index = params[:p] || 1
  domain = params[:domain]

  condition = "domain='#{domain}'"

  case params[:status]
  when /All/
  when /Cached/
    condition += " and status_code=200"
  when /Queued/
    condition += " and status_code=0"
  when /Failed/
    condition += " and status_code>200"
  end

  total = Page.where(condition).count

  pages_block = Page.where(condition).
     paginate(per_page: 10, page: page_index).
     order('updated_at DESC')

  json total: total, pages: pages_block
end

get "/pages/:md5" do
  page = Page.find_by(md5: params[:md5])

  if page.nil?
    status 404
    "page is not found"
  else
    case CONFIG[:storage]
    when :s3
      redirect "https://s3-#{CONFIG[:s3_region]}.amazonaws.com/rspider/#{page.domain}/#{page.md5}"
    when :fs
      code = settings.cache.exists?(page.url) ? 200 : 404
      body = nil

      settings.cache.get page.url do |content|
        body = content
      end

      status code
      body || "#{page.url} is not found"
    end
  end
end

get "/pages/:md5/extract" do
  page = Page.find_by(md5: params[:md5])

  if page.nil?
    status 404
    "page is not found"
  else
    result = {}
    settings.cache.get(page.url) do |body|
      settings.extractor.select(page.url, body) do |record|
        result = record
      end
    end

    json result
  end
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


post "/pages/retry" do
  count = 0

  Page.where(status_code: 777).each do |page|
    page.status_code = 0
    Resque.enqueue(Spider, {url: page.url, md5: page.md5})
    page.save
    count += 1
  end

  json totalRetriedUrls: count
end

post "/pages/upload" do
  urls = request.body.read.to_s.split "\n"
  urls.each do |url|
    page_url = WWW::URL.new url

    page = Page.find_by(md5: page_url.md5)
    if page.nil?
      page = Page.new do |p|
        p.url = url
        p.md5 = page_url.md5
        p.domain = page_url.domain
      end
      page.save
    end

    Resque.enqueue(Spider, {url: page.url, md5: page.md5})
  end

  json totalUrls: urls.size
end
